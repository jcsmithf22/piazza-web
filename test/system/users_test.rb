require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "new user can sign up" do
    visit root_path

    click_on I18n.t("application.navbar.sign_up")

    fill_in User.human_attribute_name(:name), with: "Newman"
    fill_in User.human_attribute_name(:email), with: "newman@example.com"
    fill_in User.human_attribute_name(:password), with: "short"
    fill_in User.human_attribute_name(:password_confirmation), with: "short"

    click_on I18n.t("users.new.sign_up")
    assert_selector "p.is-danger",
                    text:
                      I18n.t(
                        "activerecord.errors.models.user.attributes.password.too_short"
                      )
    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation),
            with: "wrongpassword"

    click_on I18n.t("users.new.sign_up")
    assert_selector "p.is-danger",
                    text:
                      I18n.t(
                        "activerecord.errors.models.user.attributes.password_confirmation.confirmation"
                      )

    fill_in User.human_attribute_name(:password), with: "password"
    fill_in User.human_attribute_name(:password_confirmation), with: "password"

    click_on I18n.t("users.new.sign_up")
    assert_selector ".notification",
                    text: I18n.t("users.create.welcome", name: "Newman")

    assert_selector ".navbar-dropdown", visible: false
  end

  test "existing user can log in" do
    visit root_path

    click_on I18n.t("application.navbar.login")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "wrongpassword"

    click_button I18n.t("sessions.new.submit")
    assert_selector ".notification.is-danger",
                    text: I18n.t("sessions.create.incorrect-details")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in User.human_attribute_name(:password), with: "password"

    click_button I18n.t("sessions.new.submit")
    assert_selector ".notification.is-success",
                    text: I18n.t("sessions.create.success")
    assert_selector ".navbar-dropdown", visible: false
  end
end
