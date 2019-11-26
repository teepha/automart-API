require 'test_helper'

class BodyTypeTest < ActiveSupport::TestCase
  def setup
    @bodytype = BodyType.new
  end

  test "should not be valid without a title" do
    refute @bodytype.valid?
  end

  test "should be valid with a title" do
    @bodytype.title = "car"
    assert @bodytype.valid?
  end
end
