require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "redirects to feed after successful signup" do
    get sign_up_path
    assert_response :ok

    assert_difference %w[User.count Organization.count], 1 do
      post sign_up_path,
           params: {
             user: {
               name: "John",
               email: "johndoe@example.com",
               password: "password"
             }
           }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_select ".notification.is-success",
                  text: I18n.t("users.create.welcome", name: "John")
  end

  test "renders errors if input is invalid" do
    get sign_up_path
    assert_response :ok

    assert_no_difference %w[User.count Organization.count] do
      post sign_up_path,
           params: {
             user: {
               name: "John",
               email: "johndoe@example.com",
               password: "pass"
             }
           }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger",
                  text:
                    I18n.t(
                      "activerecord.errors.models.user.attributes.password.too_short"
                    )
  end

  test "renders errors if passwords do not match" do
    get sign_up_path
    assert_response :ok

    assert_no_difference %w[User.count Organization.count] do
      post sign_up_path,
           params: {
             user: {
               name: "John",
               email: "johndoe@example.com",
               password: "password",
               password_confirmation: "wrong_password"
             }
           }
    end

    assert_response :unprocessable_entity
    assert_select "p.is-danger",
                  text:
                    I18n.t(
                      "activerecord.errors.models.user.attributes.password_confirmation.confirmation"
                    )
  end
end