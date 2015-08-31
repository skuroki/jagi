require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails'

# FIXME: うまく動かない。あとで修正します。
# require 'capistrano3/unicorn'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
