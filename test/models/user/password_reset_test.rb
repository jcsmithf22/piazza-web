require "test_helper"
class User::PasswordResetTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @user = users(:jerry)
    ActionMailer::Base.deliveries.clear
  end

  test "resetting a user's password destroys all sessions and sends reset email" do
    @user.app_sessions.create
    @user.app_sessions.create

    @user.reset_password

    assert_emails 1
    assert_empty @user.app_sessions
  end

  test "can retrieve a user with a valid password reset token" do
    token = @user.generate_token_for(:password_reset)

    user = User.find_by_token_for(:password_reset, token)

    assert_equal @user, user
  end

  test "retrieving a user with an invalid token returns nil" do
    assert_nil User.find_by_token_for(:password_reset, "invalid")
  end

  test "retrieving a user with an expired token returns nil" do
    token = @user.generate_token_for(:password_reset)

    travel_to 3.hours.from_now

    assert_nil User.find_by_token_for(:password_reset, token)
  end

  test "retrieving a user with an outdated token returns nil" do
    @user.reset_password
    token = @user.generate_token_for(:password_reset)

    @user.update(password: "new_password")

    assert_nil User.find_by_token_for(:password_reset, token)
  end
end
