BPDoc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
##  config.action_view.debug_rjs             = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "mail.ad.bankperm.ru",
    :port                 => 25,
    :domain               => 'ad.bankperm.ru',
    #:user_name            => 'bp1step',
    #:password             => 'password',
    #:authentication       => 'plain',
    :enable_starttls_auto => true  }

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  config.eager_load = false

  I18n.enforce_available_locales = false

  Paperclip.options[:command_path] = "/usr/bin/"

end

