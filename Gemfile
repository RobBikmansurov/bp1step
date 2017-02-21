# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'will_paginate', '~> 3.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'therubyracer'

gem 'devise', '~> 3.5.2' # , git: "https://github.com/plataformatec/devise"
gem 'devise_ldap_authenticatable'
gem 'cancancan', '~> 1.10'
gem 'alphabetical_paginate'
gem 'haml-rails'
gem 'execjs'

gem 'rails3-jquery-autocomplete' # , git: 'https://github.com/francisd/rails3-jquery-autocomplete'
gem 'awesome_nested_set' # , :git => 'git://github.com/collectiveidea/awesome_nested_set'
gem 'the_sortable_tree', '>= 2.4.0'
gem 'simple_form'
gem 'odf-report'
gem 'public_activity'
gem 'paperclip', '~> 4.2'
# gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem 'acts-as-taggable-on'
gem 'protected_attributes'
gem 'chartkick'
gem 'groupdate'
gem 'jcrop-rails-v2'
gem 'tiny_tds'
gem 'tzinfo-data'
gem 'pg_search'
gem 'pdf-reader'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano' # Deploy with Capistrano
  gem 'rvm-capistrano', require: false
  gem 'capistrano-deploy', require: false
  gem 'rubocop', require: false
  # gem "rails-erd"
  gem 'guard-rspec', require: false
end

group :production do
  gem 'pg'
  gem 'puma'
  gem 'unicorn'
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'sqlite3'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'selenium-webdriver'
  gem 'fuubar'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: false
  gem 'codecov', require: false, group: :test
end

gem 'rails_12factor', group: :production

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
end
