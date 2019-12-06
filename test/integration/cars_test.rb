require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest
  describe Car do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }
    let(:admin){ User.create(first_name: "Test", last_name: "User", email: "admin@user.com",
                                    password: "password", is_admin: true) }

    let(:headers){ token_generator(user.id) }
    let(:headers2){ token_generator(user2.id) }
    let(:admin_headers){ token_generator(admin.id) }

    let(:invalid_headers){ expired_token_generator(user.id) }
    let(:valid_params){{ user: user, state: "new", price: 120000.5, model: "Accord",
                                  manufacturer: "Honda", body_type: "bus" }}
    let(:update_params){{ user: user, state: "new", price: 150000.5, model: "Camry",
                                  manufacturer: "Toyota", body_type: "minibus", status: "sold" }}
    
    describe 'POST #create' do
      it "can create a car with valid parameters" do
        post "/cars", params: valid_params, headers: { 'Authorization': headers }
        assert_equal 201, status
        assert_match 'Car AD was created successfully', json_response[:message]
      end

      it "invalid car submission results in failure" do
        post "/cars", params: {}, headers: { 'Authorization': headers }
        assert_equal 422, status
        assert_match 'Invalid credentials', json_response[:error]
      end

      it "should return an error if token is not supplied" do
        post "/cars", params:  valid_params
        assert_equal 403, status
        assert_match 'Missing token', json_response[:error]
      end

      it "should return an error if token has expired" do
        post "/cars", params: valid_params,
          headers: { 'Authorization': invalid_headers }
        assert_equal 422, status
        assert_match 'Signature has expired', json_response[:error]
      end
    end

    describe 'GET #show' do
      describe 'when valid request' do
        let(:car){ Car.create!(valid_params) }
        before { get "/cars/#{car.id}", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it "returns a car AD" do
          assert_equal car.id, json_response[:data][:id]
          assert_equal car.user_id, json_response[:data][:user_id]
        end
      end

      describe 'when invalid request' do
        before { get '/cars/1', headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_equal 404, status
        end

        it "returns a car AD" do
          assert_equal "Couldn't find Car with 'id'=1", json_response[:error]
        end
      end
    end

    describe  'PUT #update' do
      let(:car){ Car.create!(valid_params) }

      describe 'when valid request for user' do
        before { put "/cars/#{car.id}", params: update_params, headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it "returns the updated car AD" do
          assert_equal "sold", json_response[:data][:status]
          assert_equal update_params[:price], json_response[:data][:price]
        end

        it 'returns a success message' do
          assert_match 'Car AD was updated successfully', json_response[:message]
        end
      end

      describe 'when invalid request for another user' do
        before { put "/cars/#{car.id}", params: update_params, headers: { 'Authorization': headers2 } }

        it 'returns a forbidden status' do
          assert_equal 403, status
        end

        it 'returns an error message' do
          assert_equal 'Unauthorized request', json_response[:error]
        end
      end

      describe 'when invalid request for user' do
        let(:car){ Car.create!(update_params) }
        before { put "/cars/#{car.id}", params: update_params, headers: { 'Authorization': headers } }

        it 'returns an unprocessable status' do
          assert_equal 422, status
        end

        it 'returns an error message' do
          assert_match 'Only cars marked as available, can be updated', json_response[:error]
        end
      end
    end

    describe 'DELETE #destroy' do
      describe 'when valid request' do
        let(:car){ Car.create!(valid_params) }
        before { delete "/cars/#{car.id}", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it 'returns a success message' do
          assert_match 'Car AD was deleted successfully', json_response[:message]
        end
      end

      describe 'when invalid request' do
        let(:car){ Car.create!(update_params) }
        before { delete "/cars/#{car.id}", headers: { 'Authorization': headers } }

        it 'returns a forbidden status' do
          assert_equal 403, status
        end

        it 'returns an error message' do
          assert_match 'Only cars marked as available, can be deleted', json_response[:error]
        end
      end

      describe 'when invalid request for another user' do
        let(:car){ Car.create!(valid_params) }
        before { delete "/cars/#{car.id}", headers: { 'Authorization': headers2 } }

        it 'returns a forbidden status' do
          assert_equal 403, status
        end

        it 'returns an error message' do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end

      describe 'when valid request for admin' do
        let(:car){ Car.create!(update_params) }
        before { delete "/cars/#{car.id}", headers: { 'Authorization': admin_headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it 'returns a success message' do
          assert_match 'Car AD was deleted successfully', json_response[:message]
        end
      end
    end
  
    describe 'GET #index' do
      describe 'when valid request' do
        before { get "/cars", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it "returns all cars" do
          assert_equal 2, json_response[:data].length
        end
      end

      describe 'when there are no car' do
        before do
          get "/cars", headers: { 'Authorization': headers }
          json_response[:data].clear
        end

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it "returns an empty array" do
          assert_equal 0, json_response[:data].length
        end
      end
    end

  end
end
