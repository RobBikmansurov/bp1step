BPDoc::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false
  ## config.action_controller.page_cache_directory = "#{Rails.root}/public/cached_pages"

  # Show full error reports and disable caching
  config.consider_all_requests_local = true # for the better_errors
  ##  config.action_view.debug_rjs             = false
  #config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # for mailcatcher
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }

  config.action_mailer.raise_delivery_errors = true
  
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  I18n.enforce_available_locales = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  Paperclip.options[:command_path] = "/usr/bin/"

  config.eager_load = false
  config.log_level = :debug

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local
  config.active_storage.routes_prefix = '/files'


  config.x.letters.path_to_portal = 'portal'
  config.x.letters.path_to_rps = 'svk_in'
  config.x.dms.path_to_h_tmp = 'h_tmp'
  config.x.dms.process_ko = 14  # id процесса ЭДО. Распоряжения КО

end
