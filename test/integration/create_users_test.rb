require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest
  describe User do
    let(:valid_parameters) { { first_name: "Test", last_name: "User", 
                        email: "test2@user.com", password: "password" }}
    let(:invalid_parameters) { { first_name: "Test", last_name: "User", 
                        email: "test", password: "password" }}
    let(:user) { User.create valid_parameters }

    it "creates a new user" do
      post "/signup", params: valid_parameters
      assert_equal 201, status
      assert_match 'Account created successfully', json_response[:message]
    end

    it "invalid user submission results in failure" do
      post "/signup", params: invalid_parameters
      assert_equal 422, status
      assert_match 'Invalid credentials', json_response[:error]
    end

    it "email should be unique" do
      post "/signup",
        params: {first_name: user.first_name, last_name: user.last_name, 
                          email: user.email, password: "password"}
      assert_match 'Account already exists', json_response[:error]
    end
  end
end
