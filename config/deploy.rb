# config valid only for current version of Capistrano
lock '3.6.0'

set :application, 'kakeibo'
#set :repo_url, 'git@example.com:me/my_repo.git'
set :repo_url, 'git@bitbucket.org:ken_murata/kakeibo.git'


# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, ENV['BRANCH'] || 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/kakeibo'

# シンボリックリンクをはるフォルダ・ファイル
set :linked_files, %w{.env config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}

# 保持するバージョンの個数(※後述)
set :keep_releases, 5

# Rubyのバージョン
set :rbenv_ruby, '2.3.0'
###set :rbenv_ruby, '2.3.0'
set :rbenv_type, :system

#出力するログのレベル。
set :log_level, :debug

# wheneverによるcrontabの設定
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }


namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end
  desc 'Generate sitemap'
  task :sitemap do
    on roles(:app) do
      within release_path do
        execute :bundle, :exec, :rake, 'sitemap:create RAIS_ENV=production'
      end
    end
  end
  
  #desc 'set crontab'
  #task :whenever do
  #  on roles(:app) do
  #
  #    # 前回の奴を削除 <-- 動かない
  #    #within previous_release do
  #      #execute :bundle, :exec, 'whenever --clear-crontab'
  #    #end
  #    
  #    within release_path do
  #      #execute :bundle, :exec, 'whenever --update-crontab'
  #      execute :bundle, :exec, 'whenever --write-crontab'
  #    end
  #  end
  #end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
  
  #after :deploy, "deploy:sitemap"
  #after :deploy, 'deploy:whenever'
end