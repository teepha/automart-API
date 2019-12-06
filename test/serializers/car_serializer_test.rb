require 'test_helper'

class CarSerializerTest < ActionDispatch::IntegrationTest
  describe CarSerializer do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }

    let(:car){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus") }

    it 'returns all attributes' do
      serializer = CarSerializer.new(car)
      fields = [:id, :user_id, :state, :status, :price, :manufacturer, :model, :body_type, :orders]
      assert_equal fields, serializer.attributes.keys
    end

    it 'checks that the response is not empty' do
      serializer = CarSerializer.new(car)
      response = serializer.to_json()
      assert_not_empty response
    end

    it 'has orders' do
      serializer = CarSerializer.new(car)
      response = serializer.orders.to_json()
      assert_equal 2, response.length
      assert_not_empty response
    end
  end
end
