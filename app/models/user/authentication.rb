module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates :password,
              on: %i[create password_change],
              presence: true,
              length: {
                minimum: 8
              }

    has_many :app_sessions
  end

  class_methods do
    def create_app_session(email:, password:)
      user = User.authenticate_by(email: email, password: password)
      user.app_sessions.create if user.present?
    end
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
