require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # TDD is perfect for Database Model validation.
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = nil
    assert_not @user.valid?
    @user.name = ""
    assert_not @user.valid?
    @user.name = "Example User"
    assert @user.valid?
  end

  test "name shouldn't be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end

  test "should take valid emails only" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test "email should be unique" do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end

  test "email should be case-insensitive" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "should have minimum password length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "user should be authenticated with password provided" do
    assert @user.authenticate("foobar")
    assert_not @user.authenticate("thisorthat")
  end

  test "email should be lowercased before saving to db" do
    @user.email = "Foo@bar.com"
    @user.save
    assert_equal @user.email.downcase, @user.reload.email, "Email was not lowercase"
  end

  test "don't allow consequetive dots in email domain address" do
    @user.email = "foo@bar..baz"
    @user.save
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
