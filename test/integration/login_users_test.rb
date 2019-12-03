require 'test_helper'

class LoginUsersTest < ActionDispatch::IntegrationTest
  describe User do
    let(:user){ User.create(first_name: "First", last_name: "User", 
                      email: "first@user.com", password: "password") }
    let(:valid_params) {{email: user.email, password: "password"}}
    let(:invalid_params) {{email: "test2@user.com", password: "password"}}

    it "can login a user" do
      post "/auth/login", params: valid_params
      assert_response :success
      assert_equal 200, status
      assert_match 'Login was successful', json_response[:message]
    end

    it "results in failure if credentials are invalid" do
      post "/auth/login", params: invalid_params
      assert_equal 400, status
      assert_match 'Invalid credentials', json_response[:error]
    end
  end
end
