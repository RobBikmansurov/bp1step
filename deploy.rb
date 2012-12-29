# Capistrano configuration
# 
# require 'new_relic/recipes'         - Newrelic notification about deployment
# require 'capistrano/ext/multistage' - We use 2 deployment environment: staging and production.
# set :deploy_via, :remote_cache      - fetch only latest changes during deployment
# set :normalize_asset_timestamps     - no need to touch (date modification) every assets
# "deploy:web:disable"                - traditional maintenance page (during DB migrations deployment)
# task :restart                       - Unicorn with preload_app should be reloaded by USR2+QUIT signals, not HUP
#
# http://unicorn.bogomips.org/SIGNALS.html
# "If “preload_app” is true, then application code changes will have no effect; 
# USR2 + QUIT (see below) must be used to load newer code in this case"
# 
# config/deploy.rb


require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'new_relic/recipes'

set :stages,                     %w(staging production)
set :default_stage,              "staging"

set :scm,                        :git
set :repository,                 "..."
set :deploy_via,                 :remote_cache
default_run_options[:pty]        = true

set :application,                "app"
set :use_sudo,                   false
set :user,                       "app"
set :normalize_asset_timestamps, false


# Optional
before "deploy",                 "deploy:web:disable"
before "deploy:stop",            "deploy:web:disable"

after  "deploy:update_code",     "deploy:symlink_shared"

# Optional
after  "deploy:start",           "deploy:web:enable"
after  "deploy",                 "deploy:web:enable"

after  "deploy",                 "deploy:cleanup"


namespace :deploy do

  %w[start stop].each do |command|
    desc "#{command} unicorn server"
    task command, :roles => :app, :except => { :no_release => true } do
      run "#{current_path}/config/server/#{rails_env}/unicorn_init.sh #{command}"
    end
  end

  desc "restart unicorn server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{current_path}/config/server/#{rails_env}/unicorn_init.sh upgrade"
  end


  desc "Link in the production database.yml and assets"
  task :symlink_shared do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end


  namespace :web do
    desc "Maintenance start"
    task :disable, :roles => :web do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      page = File.read("public/503.html")
      put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
    
    desc "Maintenance stop"
    task :enable, :roles => :web do
      run "rm #{shared_path}/system/maintenance.html"
    end
  end

end


namespace :log do
  desc "A pinch of tail"
  task :tailf, :roles => :app do
    run "tail -n 10000 -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      puts "#{data}"
      break if stream == :err
    end
  end
end