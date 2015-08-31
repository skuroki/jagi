set :stage, :production
set :rails_env, :production

server 'jagi', user: 'jagi', roles: %w{web app db}

set :linked_dirs, %w{tmp/pids tmp/sockets public/uploads}

paths = [ENV["HOME"]+'/.ssh/id_rsa']
paths.unshift ENV["PRIVATE_KEY_PATH"] if ENV.has_key? 'PRIVATE_KEY_PATH'
set :ssh_options, {
  keys: paths,
  forward_agent: true,
}

set :unicorn_roles, :web
set :unicorn_rack_env, :production
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :unicorn_config_path, "#{current_path}/config/unicorn.rb"
