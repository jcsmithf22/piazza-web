class UserMailer < ApplicationMailer
  before_action { @user = params[:user] }

  default to: -> { %("#{@user.name}" <#{@user.email}>) }

  def password_reset(token)
    @password_reset_token = token

    mail subject: t(".subject")
  end
end
