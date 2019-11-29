require 'test_helper'

class UserTest < ActiveSupport::TestCase
  describe User do
    let(:valid_params){{ first_name: "John", last_name: "Test",
                        email: "johntest@example.com", password: "password" }}
    let(:user) { User.create!(valid_params) }

    it 'is valid with valid params' do
      assert user.valid?
    end

    it "is invalid without first_name and last_name" do
      user.first_name = nil
      user.last_name = nil
      refute user.valid?
    end

    it "is invalid without an email" do
      user.email = nil
      refute user.valid?
      refute_nil user.errors[:email]
    end

    it "is invalid if email is not unique" do
      user2 = User.create({ first_name: "Name", last_name: "Test",
                        email: user.email, password: "password" })
      refute user2.valid?
      refute_nil user2.errors[:email]
    end

    it 'verifies user association with cars' do
      assert user.respond_to?(:cars)
    end

    it 'verifies user association with orders' do
      assert user.respond_to?(:orders)
    end
  end
end
