# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.3.1'

gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails' # , '~> 5.0.5'
gem 'rails', '4.2.7.1'
gem 'sass-rails', '~> 4.0.0'
gem 'therubyracer'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate', '~> 3.0'

gem 'alphabetical_paginate'
gem 'cancancan', '~> 1.10'
gem 'devise', '~> 3.5.2' # , git: "https://github.com/plataformatec/devise"
gem 'devise_ldap_authenticatable'
# gem 'execjs'
gem 'haml-rails'

gem 'awesome_nested_set' # , :git => 'git://github.com/collectiveidea/awesome_nested_set'
gem 'odf-report'
gem 'paperclip', '~> 5.1'
gem 'public_activity'
gem 'rails3-jquery-autocomplete' # , git: 'https://github.com/francisd/rails3-jquery-autocomplete'
gem 'simple_form'
gem 'the_sortable_tree', '>= 2.4.0'
# gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem 'acts-as-taggable-on'
gem 'chartkick'
gem 'groupdate'
gem 'jcrop-rails-v2'
gem 'pdf-reader'
gem 'pg_search'
gem 'protected_attributes'
gem 'tiny_tds' # , '~> 0.7.0' # MS SQL
gem 'tzinfo-data'

gem 'exception_notification'
gem 'whenever', require: false # cron jobs (crontab -l, crontab -e)

gem 'actionpack-action_caching'
gem 'actionpack-page_caching' # кеширование

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~>3.8.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'haml_lint', require: false
  # gem "rails-erd"
  gem 'capistrano-rails-db'
  gem 'capistrano3-puma'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'sshkit-sudo'
end

group :production, :staging do
  gem 'pg'
  gem 'puma'
  gem 'rails_12factor', require: false
  # gem 'unicorn'
  gem 'rails-dom-testing'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'codecov', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'sqlite3'
  gem 'webrat'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
end
