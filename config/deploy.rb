require 'rvm/capistrano'
# config valid only for Capistrano 3.1
lock '3.1.0'

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,'')
set :rvm_type, :system
set :application, 'circle-time'
set :repo_url, 'git@github.com:supernova32/circle-time.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/www-data/circle-time'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
#set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Check that we can access everything'
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :stop_websocket do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        if test("[ -w #{current_path.join('tmp/pids/websocket_rails.pid')} ]")
          execute :bundle, 'exec rake websocket_rails:stop_server RAILS_ENV=production'
        end
      end
    end
  end

  task :start_websocket do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, 'exec rake websocket_rails:start_server RAILS_ENV=production'
      end
    end
  end

  before :updating, :stop_websocket

  after :publishing, :restart

  after :restart, :start_websocket

end
