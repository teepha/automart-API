require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  describe Order do
    before do
      @user = User.create(first_name: "First", last_name: "User", 
                      email: "first@user.com", password: "password")
      @car = Car.create(user: @user, state: "used", status: "available", price: 1.5,
                      manufacturer: "MyString", model: "MyString", body_type: "bus")
    end
    let(:order){ Order.new({ user: @user, car: @car, amount: 1.5, status: "pending" }) }

    it "is invalid without an amount" do
      order.amount = nil
      refute order.valid?
    end

    it "is valid with valid parameters" do
      assert order.valid?
    end

    it 'verifies that order belongs to user' do
      assert order.respond_to?(:user)
    end

    it 'verifies that order belongs to car' do
      assert order.respond_to?(:car)
    end
  end
end
