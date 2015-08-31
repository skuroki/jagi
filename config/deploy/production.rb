set :stage, :production

server 'jagi', user: 'jagi', roles: %w{web app db}

set :linked_dirs, %w{tmp/pids tmp/sockets}

paths = [ENV["HOME"]+'/.ssh/id_rsa']
paths.unshift ENV["PRIVATE_KEY_PATH"] if ENV.has_key? 'PRIVATE_KEY_PATH'
set :ssh_options, {
  keys: paths,
  forward_agent: true,
}

# FIXME: capistrano+unicon による起動・再起動がうまくいかない。
# tmo/sokets tmp/pids にシンボリックリンクを貼ると エラー。jagiユーザーで実行すると何故かうまくいかない。あとで修正します。

# set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"
# set :unicorn_rack_env, -> { 'production' }
# set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }
# set :unicorn_roles, -> { :jagi }

# FIXME: capistrano+unicon による起動・再起動がうまくいかない。あとで修正します。

# namespace :deploy do
#   task :start do
#     invoke 'unicorn:start'
#   end

#   task :stop do
#     invoke 'unicorn:stop'
#   end

#   task :restart do
#     invoke 'unicorn:legacy_restart'
#   end
# end
