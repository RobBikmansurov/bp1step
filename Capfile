# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
# require 'capistrano/unicorn_nginx'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/rails/db'
require 'sshkit/sudo'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/puma'
install_plugin Capistrano::Puma # Default puma tasks
install_plugin Capistrano::Puma::Workers # if you want to control the workers (in cluster mode)
# install_plugin Capistrano::Puma::Monit  # if you need the monit tasks
install_plugin Capistrano::Puma::Nginx # if you want to upload a nginx site template

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
