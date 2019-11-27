require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @order = orders(:one)
  end

  test "should not be valid without an amount" do
    @order.amount = nil
    refute @order.valid?
  end

  test "should be valid" do
    assert @order.valid?
  end

  test 'that order belongs to user' do
    assert @order.respond_to?(:user)
  end

  test 'that order belongs to car' do
    assert @order.respond_to?(:car)
  end
end
