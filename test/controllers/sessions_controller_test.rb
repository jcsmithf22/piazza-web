require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:jerry) }

  test "user is logged in and redirected to home with correct credentials" do
    assert_difference "@user.app_sessions.count", 1 do
      log_in @user

      assert_not_empty cookies[:app_session]
      assert_redirected_to root_path
    end
  end

  test "error is rendered for login with incorrect credentials" do
    log_in @user, password: "wrongpassword"

    assert_response :unprocessable_entity
    assert_select ".notification", I18n.t("sessions.create.incorrect-details")
  end
end
