require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  describe Order do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }
    let(:user3){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test3@user.com", password: "password") }
    let(:admin){ User.create(first_name: "Test", last_name: "Admin", email: "admin@user.com",
                                    password: "password", is_admin: true) }

    let(:headers){ token_generator(user.id) }
    let(:headers2){ token_generator(user2.id) }
    let(:headers3){ token_generator(user3.id) }
    let(:admin_headers){ token_generator(admin.id) }

    let(:car){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus") }
    let(:car2){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus", status: "sold") }

    let(:valid_params){{ user: user2, car: car, amount: 100000.0 }}
    let(:valid_params2){{ user: user2, car: car, amount: 110000.0, status: "accepted" }}

    let(:update_params){{ amount: 110000.0 }}

    describe 'POST #create' do
      describe 'when valid request' do
        before { post "/cars/#{car.id}/orders", params: valid_params,
                          headers: { 'Authorization': headers2 } }

        it 'creates a new order' do
          assert_response 201
          assert_equal car.id, json_response[:data][:car_id]
        end

        it 'returns a success message' do        
          assert_match 'Order was created successfully', json_response[:message]
        end
      end

      describe 'when car AD does not exist' do
        before { post '/cars/100/orders', params: valid_params,
                          headers: { 'Authorization': headers } }

        it 'returns a not_found status' do
          assert_response 404
        end

        it "should return an error message" do
          assert_match "Resource not found", json_response[:error]
        end
      end

      describe 'when invalid order submission ' do
        before { post "/cars/#{car.id}/orders", params: {}, headers: { 'Authorization': headers2 } }

        it 'returns an unprocessable_entity status' do
          assert_response 422
        end

        it 'invalid order submission results in failure' do
          assert_match 'Invalid credentials', json_response[:error]
        end
      end

      describe 'when car AD has been marked as sold' do
        before { post "/cars/#{car2.id}/orders", params: valid_params,
                          headers: { 'Authorization': headers2 } }
        it "should return a forbidden status" do
          assert_response 403
        end

        it "should return an error message" do
          assert_match 'Sorry, this car is no longer available', json_response[:error]
        end
      end
      
      describe 'when invalid request' do
        before { post "/cars/#{car.id}/orders", params: valid_params,
                          headers: { 'Authorization': headers } }
        it "should return a forbidden status" do
          assert_response 403
        end

        it "should return an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'GET #show' do
      let(:order){ Order.create!(valid_params) }

      describe 'when valid request' do
        before { get "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns an order" do
          assert_equal order.id, json_response[:order][:id]
          assert_equal order.user_id, json_response[:order][:user_id]
        end
      end

      describe 'when order does not exist' do
        before { get "/cars/#{car.id}/orders/1", headers: { 'Authorization': headers } }

        it 'returns a not_found status' do
          assert_response 404
        end

        it "returns an error message" do
          assert_match "Resource not found", json_response[:error]
        end
      end

      describe 'when invalid request' do
        before { get "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': headers3 } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'GET #index' do
      describe 'when valid request' do
        before { get "/cars/#{car.id}/orders", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns all orders" do
          assert_equal 2, orders.length
        end
      end

      describe 'when there are no orders' do
        before { get "/cars/#{car.id}/orders", headers: { 'Authorization': headers } }

        it 'returns an ok status' do
          assert_response 200
        end

        it "returns an empty array" do
          assert_equal 0, json_response[:orders].length
        end
      end

      describe 'when invalid request' do
        before { get "/cars/#{car.id}/orders", headers: { 'Authorization': headers3 } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'PUT #update' do
      let(:order){ Order.create!(valid_params) }
      let(:order2){ Order.create!(valid_params2) }

      describe 'when valid request for user' do
        before { put "/cars/#{car.id}/orders/#{order.id}", params: update_params,
                          headers: { 'Authorization': headers2 }  }
        
        it 'return an ok status' do
          assert_response 200
        end

        it "returns the updated order" do
          assert_equal update_params[:amount], json_response[:data][:amount]
        end

        it 'returns a success message' do
          assert_match 'Order was updated successfully', json_response[:message]
        end
      end

      describe 'when the order being updated has been accepted' do
        before { put "/cars/#{car.id}/orders/#{order2.id}", params: update_params,
                          headers: { 'Authorization': headers2 }  }
        
        it 'return an ok status' do
          assert_response 422
        end

        it 'returns a success message' do
          assert_match 'Sorry, this order has been marked as accepted or rejected', json_response[:error]
        end
      end

      describe 'when another user makes an invalid request' do
        before { put "/cars/#{car.id}/orders/#{order.id}", params: update_params,
                          headers: { 'Authorization': headers3 }  }
        
        it 'return an ok status' do
          assert_response 403
        end

        it 'returns a success message' do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'PUT #update_status' do
      let(:order){ Order.create!(valid_params) }
      let(:order2){ Order.create!(valid_params2) }

      describe 'when valid request for car seller' do
        before { put "/cars/#{car.id}/orders/#{order.id}/status", params: { status: "accepted" },
                          headers: { 'Authorization': headers }  }
        
        it 'return an ok status' do
          assert_response 200
        end

        it "returns the updated order" do
          assert_equal "accepted", json_response[:data][:status]
        end

        it 'returns a success message' do
          assert_match 'Order status was updated successfully', json_response[:message]
        end
      end

      describe 'when the order being updated has been accepted' do
        before { put "/cars/#{car.id}/orders/#{order2.id}/status", params: { status: "accepted" },
                          headers: { 'Authorization': headers }  }
        
        it 'return an ok status' do
          assert_response 422
        end

        it 'returns a success message' do
          assert_match 'Sorry, this order has been marked as accepted or rejected', json_response[:error]
        end
      end

      describe 'when another user tries to update the status' do
        before { put "/cars/#{car.id}/orders/#{order.id}/status", params: { status: "accepted" },
                          headers: { 'Authorization': headers2 }  }
        
        it 'return an ok status' do
          assert_response 403
        end

        it 'returns a success message' do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end
    end

    describe 'DELETE #destroy' do
      let(:order){ Order.create!(valid_params) }

      describe 'when valid request' do
        before { delete "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': headers2 } }

        it 'returns an ok status' do
          assert_response 200
        end

        it 'returns a success message' do
          assert_match 'Order was deleted successfully', json_response[:message]
        end
      end

      describe "when user tries to delete another user's order" do
        before { delete "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': headers3 } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an error message" do
          assert_match 'Unauthorized request', json_response[:error]
        end
      end

      describe 'when valid request for admin' do
        before { delete "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': admin_headers } }

        it 'returns an ok status' do
          assert_equal 200, status
        end

        it 'returns a success message' do
          assert_match 'Order was deleted successfully', json_response[:message]
        end
      end

      describe 'when invalid request' do
        let(:order){ Order.create!(valid_params2) }
        before { delete "/cars/#{car.id}/orders/#{order.id}", headers: { 'Authorization': headers2 } }

        it 'returns a forbidden status' do
          assert_response 403
        end

        it "returns an order message" do
          assert_match 'Sorry, this order has been marked as accepted or rejected', json_response[:error]
        end
      end
    end
  end
end
