class Users::PasswordsController < ApplicationController
  def update
    @user = Current.user

    @user.assign_attributes(password_params)

    if @user.save(context: :password_change)
      flash[:success] = t(".success")
      redirect_to profile_path, status: :see_other
    else
      render "users/show", status: :unprocessable_entity
    end
  end

  private

  def password_params
    params
      .require(:user)
      .permit(:password, :password_challenge)
      .with_defaults(password_challenge: "")
  end
end
