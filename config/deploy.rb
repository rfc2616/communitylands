set :application, "communitylands"
set :repository,  "git@github.com:rfc2616/communitylands.git"

set :scm, :git

set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

target = ENV['TARGET'] || 'WWW'

if target=='WWW'
  puts "Deploying to Google cloud"
  server "www.communitylands.org", :app, :web, :db, :primary => true
  set :user, "rob_heittman_solertium_com"
else
  puts "Deploying nowhere"
  server "nonexistentstaging", :app, :web, :db, :primary => true
  set :user, ""
end

set :rvm_ruby_string, 'ruby-2.1.5'

before 'deploy', 'rvm:install_rvm'
before 'deploy', 'rvm:install_ruby'

require "rvm/capistrano"

require 'bundler/capistrano'

set :unicorn_pid, "#{fetch(:current_path)}/public/system/unicorn.pid"

require 'capistrano-unicorn'

set :keep_releases, 1
after "deploy:update", "deploy:cleanup"
after "assets:precompile", "assets:clean_expired"

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

after 'deploy:restart', 'unicorn:restart'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
