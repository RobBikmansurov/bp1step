build:
  languages:
    - ruby
  packages:
    - unoconv
  config:
    RAILS_ENV: staging
release:
  command:
    - cp config/database.yml{.example,}
    - cp config/ldap.yml{.example,}
    - gem install bundler --no-ri --no-rdoc    # Bundler is not installed with the image
    - bundle install --jobs=3 --without test development --path vendor  # Install dependencies into ./vendor/ruby
    # change ldap-auth to database-auth 
    - sed -i 's/config.authentication_keys = \[ :username \]/config.authentication_keys = \[ :email \]/' config/initializers/devise.rb
    - sed -i 's/devise :ldap_authenticatable/devise :database_authenticatable/g' app/models/user.rb
    - sed -i 's/before_save :ldap_email/# before_save :ldap_email/g' app/models/user.rb
    - rake db:setup
    - rake db:seed
run:
  web: bundle exec puma -C config/puma.rb
