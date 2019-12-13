require 'test_helper'

class FlagSerializerTest < ActionDispatch::IntegrationTest
  describe FlagSerializer do
    let(:user){ User.create(first_name: "Test", last_name: "User", 
                                  email: "test@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Test", last_name: "User2", 
                                    email: "test2@user.com", password: "password") }
    let(:car){ Car.create(user: user, state: "new", price: 120000.5, model: "Accord",
                                manufacturer: "Honda", body_type: "bus") }
    let(:flag){ Flag.create!(user: user2, car: car, reason: "pricing", description: "the price is too high") }

    it 'returns all attributes' do
      serializer = FlagSerializer.new(flag)
      fields = [:id, :user_id, :car_id, :reason, :description]
      assert_equal fields, serializer.attributes.keys
    end

    it 'checks that the response is not empty' do
      serializer = FlagSerializer.new(flag)
      response = serializer.to_json()
      assert_not_empty response
    end
  end
end
