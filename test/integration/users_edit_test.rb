require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
  end

  test "invalid edit data" do
    login_as @user
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), user: { name: "", email: "foo", password: "bar", password_confirmation: "baz" }
    assert_template "users/edit"
    assert_select "div.error-explanation"
    assert_select "div.field_with_errors"
  end

  test "friendly forwarding then valid edit data" do
    get edit_user_path @user
    login_as @user
    assert_redirected_to edit_user_path @user

    new_name = "John Doe"
    new_email = "john@doe.com"
    patch user_path(@user), user: { name: new_name, email: new_email, password: "", password_confirmation: "" }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end
end
