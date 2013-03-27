source 'http://rubygems.org'

gem 'rails'
gem 'sqlite3'
gem "devise"#, "~> 1.4"
gem "devise_ldap_authenticatable"
gem "cancan"
gem 'will_paginate'
gem 'haml-rails'
gem 'execjs'

gem 'rails3-jquery-autocomplete'
gem 'awesome_nested_set'
gem 'simple_form'
gem 'rb-readline'
gem 'odf-report'
gem 'public_activity'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.3.0'
end
group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem "factory_girl_rails"
  gem 'rspec-rails'
  gem 'webrat'
end

group :production do
  gem 'unicorn'   # Use unicorn as the web server
  #gem 'newrelic_rpm'
end


# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem 'thin'
  gem 'webrat'
  gem 'rspec-rails'
  gem 'capistrano'	# Deploy with Capistrano
  gem 'rvm-capistrano'
  gem 'capistrano-deploy', :require => false
end

