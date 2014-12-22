require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)   # Fixture user
  end

  test "login with invalid information" do
    # flash message should only display once, not on second
    # template rendering (which rails for some reason doesn't
    # count as a request?)
    get login_path
    assert_template "sessions/new"
    post login_path, session: { email: "", password: "" }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?  # no flash the second time around!
  end

  test "login with valid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, session: { email: @user.email, password: "password" }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert flash.empty?
    assert_select "a[href=?]", login_path, count: 0     # login link disappears
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
