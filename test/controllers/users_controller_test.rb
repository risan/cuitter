require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:foo)
    @other_user = @non_admin = users(:bar)
  end

  test "should be redirected from index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should be redirected from edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should be redirected from update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should be redirected from edit when logged in as as wrong user" do
    login_as @other_user
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should be redirected from update when logged in as as wrong user" do
    login_as @other_user
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited" do
    login_as @non_admin
    assert_not @non_admin.admin?
    patch :update, id: @non_admin, user: { password: "secret", password_confirmation: "secret", admin: true }
    assert_not @non_admin.admin?
  end

  test "should be redirected from destroy when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @non_admin
    end
    assert_redirected_to login_url
  end

  test "should be redirected from destroy when logged in as non-admin" do
    login_as @non_admin
    assert_no_difference "User.count" do
      delete :destroy, id: @non_admin
    end
    assert_redirected_to root_url
  end
end
