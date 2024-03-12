require "application_system_test_case"

class Users::PasswordResetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:jerry)

    ActionMailer::Base.deliveries.clear
  end

  test "can reset password and login" do
    visit login_path

    click_on I18n.t("sessions.new.password_reset")
    fill_in I18n.t("users.password_resets.new.email_label"), with: @user.email
    click_on I18n.t("users.password_resets.new.submit")

    assert_text I18n.t("users.password_resets.create.message")

    password_reset_path = extract_primary_link_from_last_mail
    visit password_reset_path

    fill_in User.human_attribute_name(:password), with: "pw"
    click_on I18n.t("users.password_resets.edit.submit")
    assert_selector "p.is-danger"

    fill_in User.human_attribute_name(:password), with: "W3lcome?"
    fill_in User.human_attribute_name(:password_confirmation), with: "W3lcome?"
    click_on I18n.t("users.password_resets.edit.submit")

    assert_current_path root_path
  end
end
