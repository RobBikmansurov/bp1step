BPDoc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = true

  config.action_controller.page_cache_directory = "#{Rails.root}/public/cached_pages"

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'bp1step-dev.ad.bankperm.ru' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # for mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }

  config.action_mailer.raise_delivery_errors = true

  config.assets.digest = true

  config.eager_load = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  I18n.enforce_available_locales = false

  Paperclip.options[:command_path] = "/usr/bin/"

  # exeption notification
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
    :email_prefix => "[bp1step] ",
    :sender_address => %{"client-notifier" <client-local@bankperm.ru>},
    # :exception_recipients => %w{help@bankperm.ru robb@bankperm.ru}
    :exception_recipients => %w{robb@bankperm.ru}
  }

end
