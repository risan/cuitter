require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup data" do
    get signup_path

    assert_no_difference "User.count" do
      post users_path, user: { name: "", email: "foo", password: "bar", password_confirmation: "baz" }
    end

    assert_template "users/new"
    assert_select "div.error-explanation"
    assert_select "div.field_with_errors"
  end

  test "valid signup data" do
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: { name: "foo", email: "foo@bar.baz", password: "secret", password_confirmation: "secret" }
    end

    assert_template "users/show"
    assert_not flash.empty?
    assert is_logged_in?
  end
end
