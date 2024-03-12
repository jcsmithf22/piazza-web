Rails.application.config.before_initialize do |app|
  app.message_verifiers.clear_rotations

  app.message_verifiers.rotate(url_safe: true)
  app.message_verifiers.rotate_defaults
end
