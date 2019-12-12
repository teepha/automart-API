require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  describe Flag do
    let(:user){ User.create(first_name: "First", last_name: "User", 
                          email: "first@user.com", password: "password") }
    let(:user2){ User.create(first_name: "Second", last_name: "User", 
                          email: "second@user.com", password: "password") }
    let(:car){ Car.create(user: user, state: "used", status: "available", price: 1.5,
                      manufacturer: "MyString", model: "MyString", body_type: "bus")}
    let(:flag){ Flag.new({ user: user2, car: car, reason: "pricing", description: "the price is too high" }) }

    it "is valid with valid parameters" do
      assert flag.valid?
    end

    it "is invalid without an amount" do
      flag.reason = nil
      refute flag.valid?
    end

    it 'verifies that flag belongs to user' do
      assert flag.respond_to?(:user)
    end

    it 'verifies that flag belongs to car' do
      assert flag.respond_to?(:car)
    end
  end
end
