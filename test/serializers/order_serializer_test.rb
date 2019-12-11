require 'test_helper'

class OrderSerializerTest < ActionDispatch::IntegrationTest
  describe OrderSerializer do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }
    let(:car){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus") }
    let(:order){ Order.create!(user: user2, car: car, amount: 100000.0, status: "pending") }

    it 'returns all attributes' do
      serializer = OrderSerializer.new(order)
      fields = [:id, :user_id, :car_id, :amount, :status]
      assert_equal fields, serializer.attributes.keys
    end

    it 'checks that the response is not empty' do
      serializer = OrderSerializer.new(order)
      response = serializer.to_json()
      assert_not_empty response
    end
  end
end
