require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test "should not save User without first_name last_name" do
    @user.first_name = nil
    @user.first_name = nil
    refute @user.valid?
  end

  test "invalid without email" do
    @user.email = nil
    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end

  test 'the association with cars' do
    assert_equal 2, @user.cars.size
  end

  test 'the association with orders' do
    assert_equal 2, @user.orders.size
  end
end
