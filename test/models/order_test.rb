require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  describe Order do
    let(:user){ User.create(first_name: "First", last_name: "User", 
                          email: "first@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Second", last_name: "User", 
                          email: "second@user.com", password: "password") }
    let(:car){ Car.create(user: user, state: "used", status: "available", price: 1.5,
                      manufacturer: "MyString", model: "MyString", body_type: "bus")}
    let(:order){ Order.new({ user: user2, car: car, amount: 1.5, status: "pending" }) }

    it "is valid with valid parameters" do
      assert order.valid?
    end

    it "is invalid without an amount" do
      order.amount = nil
      refute order.valid?
    end

    it 'verifies that order belongs to user' do
      assert order.respond_to?(:user)
    end

    it 'verifies that order belongs to car' do
      assert order.respond_to?(:car)
    end
  end
end
