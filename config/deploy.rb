require 'rvm/capistrano'
require 'bundler/capistrano'

server 'vrdev.ad.bankperm.ru', :app, :web, :db, :primary => true
# http and https proxy
default_environment['http_proxy'] = 'http://vstorage.ad.bankperm.ru:3128'
default_environment['https_proxy'] = 'http://vstorage.ad.bankperm.ru:3128'

set :application, "bp1step"
set :user, 'rubydev'
set :rails_env, "production"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

set :unicorn_conf, "#{deploy_to}/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/pids/unicorn.pid"

set :rvm_ruby_string, "ruby-1.9.3-p327@#{application}"
set :rvm_type, :user

set :scm, :git
set :repository,  "http://github.com/RobBikmansurov/BPDoc.git"
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.
default_run_options[:pty]        = true

set :keep_releases, 2 	# количество каталогов релизов, хранящихся на сервере

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end