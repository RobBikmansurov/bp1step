require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env) if defined?(Bundler)

module BPDoc
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    
    config.autoload_paths << Rails.root.join('app', 'policy')

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Ekaterinburg'   # 'UTC +06:00'
    #config.active_record.default_timezone = :local # так не работают графики - ActiveRecord::Base.default_timezone must be :utc to use Groupdate 
    config.active_record.default_timezone = :utc

    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.enforce_available_locales = true

    # JavaScript files you want as :defaults (application.js is always included).
    #config.action_view.javascript_expansions[:defaults] = %w(jquery rails)
    ##config.action_view.javascript_expansions[:defaults] = %w(jquery-1.6.1.min jquery-ujs/src/rails)
    config.assets.enabled = true

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    ActsAsTaggableOn.strict_case_match = true
    Rails.application.config.action_dispatch.cookies_serializer = :hybrid

    initializer 'setup_asset_pipeline', :group => :all do |app|
      # We don't want the default of everything that isn't js or css, because it pulls too many things in
      app.config.assets.precompile.shift
      # Explicitly register the extensions we are interested in compiling
      app.config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
        '.html', '.erb', '.haml', # Templates
        '.png', '.gif', '.jpg', '.jpeg', # Images
        '.eot', '.otf', '.svc', '.woff', '.ttf', # Fonts
      ]
      end)
    end
    config.action_controller.always_permitted_parameters = %w( controller action format page per_page search direction sort)
    
  end
end
