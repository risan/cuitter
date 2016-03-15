require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:foo)
    @non_admin = users(:bar)
  end

  test "index as admin has pagination and delete link" do
    login_as @admin
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"

    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name

      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete"
      end
    end

    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end

    follow_redirect!
    assert_not flash.empty?
    assert_template "users/index"
  end

  test "index as non admin has pagination" do
    login_as @non_admin
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"

    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", user_path(user), text: "delete", count: 0
    end
  end
end
