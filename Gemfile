source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.1'

gem 'will_paginate', '~> 3.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'therubyracer'
gem 'unicorn'

gem 'newrelic_rpm'


gem "devise", git: "https://github.com/plataformatec/devise"
gem "devise_ldap_authenticatable"
gem "cancan"
gem 'alphabetical_paginate'
gem 'haml-rails'
gem 'execjs'

gem 'rails3-jquery-autocomplete', git: 'https://github.com/francisd/rails3-jquery-autocomplete'
gem 'awesome_nested_set', :git => 'git://github.com/collectiveidea/awesome_nested_set'
gem "the_sortable_tree", ">= 2.4.0"
gem 'simple_form'
#gem 'rb-readline'
gem 'odf-report'
gem 'public_activity'
gem 'paperclip'
gem 'acts-as-taggable-on'
gem 'protected_attributes'


group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'webrat'
end

group :development do
  #gem 'pg'
  gem 'thin'
  #gem 'quiet_assets'
  #gem 'rails_best_practices'
  #gem 'rack-mini-profiler'
  #gem 'bullet'
  #gem 'better_errors'
  gem 'capistrano'  # Deploy with Capistrano
  gem 'rvm-capistrano'
  gem 'capistrano-deploy', :require => false
end

group :development, :test do
  gem 'rspec-rails'
  #gem 'pry'
  gem 'sqlite3'
end

group :production do
  gem 'sqlite3'
  #gem 'newrelic_rpm'
end
