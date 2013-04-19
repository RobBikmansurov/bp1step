require 'rvm/capistrano'
#require 'bundler/capistrano'

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"

load "config/recipes/monit"

server 'vrdev.ad.bankperm.ru', :app, :web, :db, :primary => true

# http and https proxy
#default_environment['http_proxy'] = 'http://vstorage.ad.bankperm.ru:3128'
#default_environment['https_proxy'] = 'http://vstorage.ad.bankperm.ru:3128'

set :application, "bp1step"
set :user, 'rubydev'
set :rails_env, "production"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

set :unicorn_conf, "#{deploy_to}/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"

set :rvm_ruby_string, "ruby-1.9.3-p385@#{application}"
set :rvm_type, :user

set :scm, :git
set :repository,  "http://github.com/RobBikmansurov/BPDoc.git"
set :branch, "master"
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.
default_run_options[:pty]        = true
ssh_options[:forward_agent] = true

set :keep_releases, 2 	# количество каталогов релизов, хранящихся на сервере

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
#after "deploy:update_code", "rvm:trust_rvmrc"
after "deploy:update_code", "deploy:create_symlink"

# Create uploads directory and link
namespace :deploy do
  task :create_symlink do
    #run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -s #{shared_path}/db/sphinx #{release_path}/db/sphinx"
    # run "ln -s #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
    run "rm -rf #{deploy_to}/current/db"
    run "ln -s -- #{deploy_to}/db #{deploy_to}/current/db"
    run "rm -rf #{deploy_to}/current/files"
    run "ln -s -- #{deploy_to}/files #{deploy_to}/current/files"
    run "cp #{deploy_to}/config/ldap.yml #{deploy_to}/current/config/ldap.yml"
  end

end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
