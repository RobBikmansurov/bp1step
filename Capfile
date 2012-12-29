#load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
#load 'config/deploy' # remove this line to skip loading any of the default tasks
require 'capistrano-deploy'
use_recipes :git, :bundle, :rails

server 'vrdev.ad.bankperm.ru', :app, :web, :db, :primary => true
set :user, 'rubydev'
set :deploy_to, "/home/rubydev/bp1step"
set :rails_env, "production"
set :repository, "git@github.com:RobBikmansurov/BPDoc.git"

after 'deploy:update', 'bundle:install'