require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new({ name: "John Doe", email: "foo@bar.baz", password: "secret", password_confirmation: "secret" })
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "name should not be more than 100 characters" do
    @user.name = "a" * 101
    assert_not @user.valid?
  end

  test "email should not be more than 255 characters" do
    @user.email = "a" * 246 + "@foooo.baz"
    assert_not @user.valid?
  end

  test "password should at least 6 characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[foo@bar.baz FOO@bar.Baz A_US-ER@foo.bar.org first.last@foo.br foo+bar@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid."
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid."
    end
  end

  test "email address should be unique" do
    @user.save

    duplicated_user = @user.dup
    duplicated_user.email.upcase!
    assert_not duplicated_user.valid?
  end
end
