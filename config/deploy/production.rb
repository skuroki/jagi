set :stage, :production
set :rails_env, :production

server 'jagi', user: 'jagi', roles: %w{web app db}

set :linked_dirs, %w{log tmp/pids tmp/sockets public/assets public/uploads}

set :ssh_options, {
  forward_agent: true,
}

set :unicorn_roles, :web
set :unicorn_rack_env, :production
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
