source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails', '4.2.3'

#gem 'yaml_db', github: 'jetthoughts/yaml_db', ref: 'fb4b6bd7e12de3cffa93e0a298a1e5253d7e92ba'

gem 'will_paginate', '~> 3.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'therubyracer'
gem 'unicorn'

gem "devise", "~> 3.5.2"#, git: "https://github.com/plataformatec/devise"
gem "devise_ldap_authenticatable"
gem 'cancancan', '~> 1.10'
gem 'alphabetical_paginate'
gem 'haml-rails'
gem 'execjs'

gem 'rails3-jquery-autocomplete'#, git: 'https://github.com/francisd/rails3-jquery-autocomplete'
gem 'awesome_nested_set' #, :git => 'git://github.com/collectiveidea/awesome_nested_set'
gem "the_sortable_tree", ">= 2.4.0"
gem 'simple_form'
gem 'odf-report'
gem 'public_activity'
gem 'paperclip', "~> 4.2"
#gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
gem 'acts-as-taggable-on'
gem 'protected_attributes'
gem 'chartkick'
gem 'groupdate'
gem 'jcrop-rails-v2'

group :test, :development do
  gem 'sqlite3'
  gem 'capybara'
  gem 'webrat'
  gem "selenium-webdriver"
end

group :test do
  gem 'shoulda-matchers', require: false
end

group :development do
  #gem 'sqlite3'
  gem 'capistrano'  # Deploy with Capistrano
  gem 'rvm-capistrano',  require: false
  gem 'capistrano-deploy', require: false
  #gem 'rubocop', require: false
  #gem "rails-erd"
  gem 'guard-rspec', require: false
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
end
