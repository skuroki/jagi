lock '3.2.1'

set :application, 'jagi'
set :repo_url, 'https://github.com/Yinaura/jagi'
set :branch, 'master'
set :deploy_to, '/var/www/app/jagi'
set :scm, :git
set :pty, true
set :format, :pretty

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }
