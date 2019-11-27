require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:valid)
  end

  test 'valid user' do
    assert @user.valid?
  end

  test "should not be valid without first_name last_name" do
    @user.first_name = nil
    @user.first_name = nil
    refute @user.valid?
  end

  test "should not be valid without email" do
    @user.email = nil
    refute @user.valid?
    refute_nil @user.errors[:email]
  end

  test 'that user has many cars' do
    assert @user.respond_to?(:cars)
  end

  test 'that user has many orders' do
    assert @user.respond_to?(:orders)
  end
end
