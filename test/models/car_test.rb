require 'test_helper'

class CarTest < ActiveSupport::TestCase
  def setup
    @car = cars(:two)
  end

  test "should be valid" do
    assert @car.valid?
  end

  test "should not be valid without price" do
    @car.price = nil
    refute @car.save
  end

  test "should not be valid without state and status" do
    @car.state = nil
    @car.status = nil
    refute @car.save
  end

  test 'that car belongs to user' do
    assert @car.respond_to?(:user)
  end

  test 'that car has many orders' do
    assert @car.respond_to?(:orders)
  end
end
