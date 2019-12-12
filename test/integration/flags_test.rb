require 'test_helper'

class FlagsControllerTest < ActionDispatch::IntegrationTest
  describe Flag do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }
    let(:admin){ User.create(first_name: "Test", last_name: "Admin", email: "admin@user.com",
                                    password: "password", is_admin: true) }

    let(:headers){ token_generator(user.id) }
    let(:headers2){ token_generator(user2.id) }
    let(:admin_headers){ token_generator(admin.id) }

    let(:car){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus") }

    let(:valid_params){{ user: user2, car: car,  reason: "pricing", description: "the price is too high" }}
    let(:update_params){{ user: user2, car: car,  reason: "weird demands", description: "the demands are too much" }}

    describe 'POST #create' do
      describe 'when valid request' do
        before { post "/cars/#{car.id}/flags", params: valid_params, headers: { 'Authorization': headers2 } }

        it 'creates a new flag' do
          assert_response 201
        end

        it 'return the new flag created' do
          assert_equal car.id, json_response[:flag][:car_id]
        end
      end

      describe 'when car AD does not exist' do
        before { post '/cars/1000/flags', params: valid_params, headers: { 'Authorization': headers } }

        it 'returns a not_found status' do
          assert_response 404
        end

        it "should return an error message" do
          assert_match "Resource not found", json_response[:error]
        end
      end

      describe 'when invalid request' do
        before { post "/cars/#{car.id}/flags", params: valid_params, headers: { 'Authorization': headers } }

        it "should return a forbidden status" do
          assert_response 403
        end

        it "should return an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'GET #index' do
      before { get "/cars/#{car.id}/flags", headers: { 'Authorization': admin_headers } }

      describe 'when valid request' do
        it 'returns an ok status' do
          assert_response 200
        end

        it "returns all flags" do
          assert_equal 2, flags.length
        end
      end

      describe 'when there are no flags' do
        it 'returns an ok status' do
          assert_response 200
        end

        it "returns an empty array" do
          assert_equal 0, json_response[:flags].length
        end
      end

      describe 'when invalid request' do
        before { get "/cars/#{car.id}/flags", headers: { 'Authorization': headers } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'GET #show' do
      let(:flag){ Flag.create!(valid_params) }

      describe 'when valid request by user' do
        before { get "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': headers2 } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns an flag" do
          assert_equal flag.id, json_response[:flag][:id]
          assert_equal flag.user_id, json_response[:flag][:user_id]
        end
      end

      describe 'when valid request by admin' do
        before { get "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': admin_headers } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns an flag" do
          assert_equal flag.id, json_response[:flag][:id]
          assert_equal valid_params[:reason], json_response[:flag][:reason]
        end
      end

      describe 'when invalid request by another user' do
        before { get "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': headers } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'PUT #update' do
      let(:flag){ Flag.create!(valid_params) }

      describe 'when valid request by user' do
        before { put "/cars/#{car.id}/flags/#{flag.id}", params: update_params,
                          headers: { 'Authorization': headers2 } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns the flag updated" do
          assert_equal update_params[:reason], json_response[:flag][:reason]
        end
      end

      describe 'when another user makes an invalid request' do
         before { put "/cars/#{car.id}/flags/#{flag.id}", params: update_params,
                          headers: { 'Authorization': headers } }
        
        it 'return an ok status' do
          assert_response 403
        end

        it 'returns a success message' do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:flag){ Flag.create!(valid_params) }

      describe 'when valid request by user' do
        before { delete "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': headers2 } }

        it 'returns an ok status' do
          assert_response 200
        end

        it 'returns a success message' do
          assert_match 'Flag was deleted successfully', json_response[:message]
        end
      end

      describe 'when valid request by admin' do
        before { delete "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': admin_headers } }

        it 'returns an ok status' do
          assert_response 200
        end

        it 'returns a success message' do
          assert_match 'Flag was deleted successfully', json_response[:message]
        end
      end

      describe 'when invalid request by another user' do
        before { delete "/cars/#{car.id}/flags/#{flag.id}", headers: { 'Authorization': headers } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it 'returns a success message' do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end
  end
end
