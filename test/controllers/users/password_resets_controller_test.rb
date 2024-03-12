require "test_helper"

class Users::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)

    ActionMailer::Base.deliveries.clear
  end

  test "creating a password reset sends an email and shows instructions" do
    post users_password_resets_path, params: { email: @user.email }

    assert_response :ok
    assert_select "p", text: I18n.t("users.password_resets.create.message")
    assert_emails 1
  end

  test "accessing the password reset page with a valid token shows the form" do
    @user.reset_password
    get edit_users_password_reset_path(
          @user.generate_token_for(:password_reset)
        )

    assert_response :ok
    assert_select "form"
  end

  test "accessing the password reset page with an invalid token or nil id redirects" do
    get edit_users_password_reset_path("invalid")
    assert_redirected_to new_users_password_reset_path

    get edit_users_password_reset_path
    assert_redirected_to new_users_password_reset_path
  end

  test "resetting the password logs in and redirects the user to the root" do
    @user.reset_password
    token = @user.generate_token_for(:password_reset)

    patch users_password_reset_path(token),
          params: {
            user: {
              password: "W3lcome?"
            }
          }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :ok

    assert @user.reload.authenticate("W3lcome?")
  end

  test "entering a password that is too short renders an error" do
    @user.reset_password
    token = @user.generate_token_for(:password_reset)

    patch users_password_reset_path(token),
          params: {
            user: {
              password: "short"
            }
          }

    assert_response :unprocessable_entity
    assert_select "p.is-danger"
  end
end
