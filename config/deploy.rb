set :application, "socket-test"
set :repository,  "git@github.com:tjsingleton/Socket.IO-Spike.git"

set :scm, :git

set :user, "cruncher"
set :use_sudo, false
set :port, 22345

ssh_options[:forward_agent] = true    # use our ssh key
default_run_options[:pty] = true      # Must be set for the password prompt from git to work

role :app, "echo-staging.crunchconnect.com"
set :deploy_to, "/home/#{user}/socket-test"
set :deploy_via, :copy
set :branch, "master"

namespace :deploy do
  task :setup_env do 
    run %Q{echo "HOSTNAME=echo-staging.crunchconnect.com" > #{deploy_to}/current/.env}
  end
end

after "deploy", "deploy:setup_env"
