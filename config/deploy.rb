# config valid only for current version of Capistrano
lock '3.10.2'

set :application, 'bp1step'
set :user, 'rubydev'
set :local_user , 'rubydev'

# set :repo_url, 'git@github.com:RobBikmansurov/bp1step.git'
set :repo_url, 'git@gitlab.ad.bankperm.ru:mr_rob/bp1step.git'

set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, "2.5.1@#{fetch(:application)}"
set :rvm_roles, [:app, :web]

# http and https proxy
set :bundle_env_variables, { http_proxy: 'http://proxy.ad.bankperm.ru:3129', https_proxy: 'http://proxy.ad.bankperm.ru:3129' }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/ldap.yml', 'config/secrets.yml', 'config/environments/production.rb')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'db', 'public/store')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :puma_rackup, -> { File.join(current_path, 'config.ru') }

set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.log"
set :puma_error_log, "#{shared_path}/log/puma.log"

set :puma_role, :app
set :puma_tag, "#{fetch(:application)}"
set :puma_threads, [2, 16]
set :puma_workers, 1
set :puma_preload_app, true
set :puma_daemonize, true

set :puma_init_active_record, true

set :bundle_jobs, 4 # default: nil, only available for Bundler >= 1.4

namespace :deploy do
  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/"
      execute "mkdir -p #{shared_path}/config/"
      execute "mkdir -p #{shared_path}/db/"
      execute "mkdir -p #{shared_path}/log/"
      execute "mkdir -p #{shared_path}/store/"
      execute "mkdir -p #{shared_path}/store/db/" # копии БД
      execute "mkdir -p #{shared_path}/store/appendix/" # приложения к Письмам
      execute "mkdir -p #{shared_path}/store/scan/" # сканы договоров
      execute "mkdir -p #{shared_path}/store/images/" # аватары пользователей


      execute "mkdir -p #{deploy_to}/svk_in/"
      execute "mkdir -p #{deploy_to}/bp1step.store/"

      # execute "mkdir -p #{shared_path}/reports/"
      #execute "mkdir #{shared_path}/system"
      #sudo "ln -s /var/log/upstart /var/www/log/upstart"

      #upload!('shared/database.yml', "#{shared_path}/config/database.yml")

      #upload!('shared/Procfile', "#{shared_path}/Procfile")

      #upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      #sudo 'stop nginx'
      #sudo "rm -f /usr/local/nginx/conf/nginx.conf"
      #sudo "ln -s #{shared_path}/nginx.conf /usr/local/nginx/conf/nginx.conf"
      #sudo 'start nginx'

      # скопируем конфигурационые файлы с секретами
      #run "cp #{deploy_to}/config/ldap.yml #{deploy_to}/current/config/ldap.yml"
      #run "cp #{deploy_to}/config/database.yml #{deploy_to}/current/config/database.yml"
      # шаблоны документов с шапками или информацией об организации
      #run "cp #{deploy_to}/secret/*.odt #{deploy_to}/current/reports/"
      # шаблон официального письма
      #run "cp #{deploy_to}/secret/bnk-letter.odt #{deploy_to}/current/reports/letter.odt"
      #run "rm -rf #{deploy_to}/current/public/store"
      #run "ln -s -- #{deploy_to}/public/store/ #{deploy_to}/current/public/store" #    app/models/document.rb :path => ":rails_root/public/store/:id.:ymd.:basename.:extension",
      #run "rm -rf #{deploy_to}/current/files"
      # execute "ln -s -- #{deploy_to}/files/ #{deploy_to}/current/files"



      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  task :copy_reports do
    on roles(:app) do
      # шаблоны документов с шапками или информацией об организации
      execute "cp #{shared_path}/secret/*.odt #{release_path}/reports/"
      # шаблон официального письма
      execute "cp #{shared_path}/secret/bnk-letter.odt #{release_path}/reports/letter.odt"
      execute "rm #{release_path}/reports/bnk-letter.odt"
      if "#{fetch(:rails_env)}" != 'staging'
        execute "ln -s #{shared_path}/config/ldap.yml #{release_path}/config/ldap.yml"
      end 
      execute "rm #{release_path}/config/environments/production.rb"
      execute "ln -s #{shared_path}/config/environments/production.rb #{release_path}/config/environments/production.rb"
    end
  end

  after 'deploy:restart', 'deploy:clear_cache' do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after 'deploy:publishing', 'deploy:copy_reports'

end


