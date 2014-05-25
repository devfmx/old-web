set :application, 'devf'
set :repo_url, %x{git config remote.origin.url}.chomp

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

set :format, :pretty
set :log_level, :info
#set :pty, true
set :git_shallow_clone, 1

set :linked_files, %w{config/database.yml config/secrets.yml .env }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

fetch(:default_env).merge!(rails_env: fetch(:stage))

server 'devf', roles: %w{web app}, ssh_options: { forward_agent: true }

namespace :deploy do
  #task :restart => 'puma:restart'
  after :finishing, 'deploy:cleanup'
end
