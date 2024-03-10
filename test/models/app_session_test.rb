require "test_helper"

class AppSessionTest < ActiveSupport::TestCase
  setup { @user = users(:jerry) }

  test "token is generated and saved when a new record is created" do
    app_session = @user.app_sessions.create

    assert app_session.persisted?
    refute app_session.token_digest.nil?
    assert app_session.authenticate_token(app_session.token)
  end
end
