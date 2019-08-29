# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '5.2.2.1'

gem 'bootsnap'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails', '5.0.5'

gem 'alphabetical_paginate'
gem 'cancancan', '~> 2.2'
gem 'devise', '~> 4.6.1' # , git: "https://github.com/plataformatec/devise"
gem 'devise_ldap_authenticatable'
gem 'will_paginate', '~> 3.0'
# gem 'execjs'
gem 'haml-rails'

gem 'awesome_nested_set' # , :git => 'git://github.com/collectiveidea/awesome_nested_set'
gem 'odf-report'
gem 'paperclip', '~> 5.2.1'
gem 'public_activity'
gem 'rails3-jquery-autocomplete' # , git: 'https://github.com/francisd/rails3-jquery-autocomplete'
gem 'simple_form'
gem 'the_sortable_tree', '>= 2.4.0'
# gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem 'acts-as-taggable-on'
gem 'chartkick'
gem 'groupdate'
gem 'jcrop-rails-v2'
# gem 'pdf-reader'
gem 'pg'
gem 'pg_search'
gem 'tiny_tds', '~> 0.7.0' # MS SQL

gem 'tzinfo-data'

gem 'exception_notification'
gem 'whenever', require: false # cron jobs (crontab -l, crontab -e)

gem 'actionpack-action_caching'
gem 'actionpack-page_caching' # кеширование

gem 'faker'

gem 'loofah' # , '>= 2.2.3'
gem 'nokogiri', '>= 1.10.4'
gem 'rack' # , '>= 2.0.6'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~>3.10.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'haml_lint', require: false
  # gem "rails-erd"
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'capistrano-rails-db'
  gem 'capistrano3-puma'
  gem 'sshkit-sudo'
  # gem 'log-analyzer', require: false
end

group :production, :staging do
  gem 'puma'
  gem 'rails_12factor', require: false
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'codecov', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'sqlite3', '~>1.3.13'
  gem 'webrat'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubycritic', require: false
  gem 'selenium-webdriver'
end
