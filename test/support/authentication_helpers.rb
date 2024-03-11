module AuthenticationHelpers
  def log_in(user, password: "password")
    post login_path,
         params: {
           user: {
             email: user.email,
             password: password,
             remember_me: "1"
           }
         }
  end

  def log_out
    delete logout_path
  end
end
