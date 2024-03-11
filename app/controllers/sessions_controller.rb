class SessionsController < ApplicationController
  skip_authentication only: %i[new create]

  def new
  end

  def create
    @app_session =
      User.create_app_session(
        email: login_params[:email],
        password: login_params[:password]
      )

    if @app_session
      log_in @app_session, remember: login_params[:remember_me] == "1"
      flash[:success] = t(".success")
      redirect_to root_path
    else
      flash.now[:danger] = t(".incorrect-details")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out

    flash[:success] = t(".success")
    redirect_to root_path, status: :see_other
  end

  private

  def login_params
    @login_params ||=
      params.require(:user).permit(:email, :password, :remember_me)
  end
end
