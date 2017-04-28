require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BPDoc
  class Application < Rails::Application
    config.time_zone = 'Ekaterinburg'   # 'UTC +06:00'

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

    ActsAsTaggableOn.strict_case_match = true
    Rails.application.config.action_dispatch.cookies_serializer = :hybrid

    config.active_record.raise_in_transactional_callbacks = true
  end
end
