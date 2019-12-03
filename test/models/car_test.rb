require 'test_helper'

class CarTest < ActiveSupport::TestCase
  describe Car do
    let(:user){User.create(first_name: "First", last_name: "User", 
                      email: "first@user.com", password: "password")}
    let(:car_params){{ user: user, state: "used", status: "available", price: 1.5,
                      manufacturer: "MyString", model: "MyString", body_type: "bus" }}
    let(:car){ Car.new car_params }

    it "is valid with valid parameters" do
      assert car.valid?
    end

    it "is invalid without a numeric price" do
      car.price = "string"
      refute car.valid?
    end

    it "is invalid without state and status" do
      car.state = nil
      car.status = nil
      refute car.save
    end

    it 'verifies cars association with user' do
      assert car.respond_to?(:user)
    end

    it 'verifies car association with orders' do
      assert car.respond_to?(:orders)
    end
  end
end
