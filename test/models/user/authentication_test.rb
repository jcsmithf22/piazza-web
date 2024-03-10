require "test_helper"

class User::AuthenticationTest < ActiveSupport::TestCase
  test "password length must be between 8 and Active Record's maximum" do
    @user = User.new(name: "John", email: "johndoe@example.com", password: "")
    refute @user.valid?

    @user.password = "password"
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    refute @user.valid?
  end

  test "can create a session with correct email and password" do
    @app_session =
      User.create_app_session(email: "jerry@example.com", password: "password")

    refute @app_session.nil?
    refute @app_session.token.nil?
  end

  test "cannot create a session with email and incorrect password" do
    @app_session =
      User.create_app_session(email: "jerry@example.com", password: "WRONG")

    assert @app_session.nil?
  end

  test "creating a session with nonexistent email returns nil" do
    @app_session =
      User.create_app_session(email: "whoami@example.com", password: "password")

    assert @app_session.nil?
  end

  test "can authenticate with a valid session id and token" do
    @user = users(:jerry)
    @app_session = @user.app_sessions.create

    assert_equal @app_session,
                 @user.authenticate_app_session(
                   @app_session.id,
                   @app_session.token
                 )
  end

  test "trying to authenticate with a token that doesn't exist returns false" do
    @user = users(:jerry)

    refute @user.authenticate_app_session(50, "token")
  end
end
