module User::PasswordReset
  extend ActiveSupport::Concern

  included do
    generates_token_for :password_reset, expires_in: 2.hours do
      password_salt.last(10)
    end
  end

  def reset_password
    app_sessions.destroy_all

    send_password_reset_email
  end

  private

  def send_password_reset_email
    token = generate_token_for(:password_reset)

    UserMailer.with(user: self).password_reset(token).deliver_now
  end
end
