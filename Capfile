require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano3/unicorn'
require 'capistrano/sitemap_generator'
require 'whenever/capistrano'

# taskを記述したファイルを読み込むよう設定。　場所と拡張子を指定。
Dir.glob('lib/capistrano/tasks/*.rb').each { |r| import r }