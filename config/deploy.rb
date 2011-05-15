ssh_options[:paranoid] = false 
set :user, 'numly'
set :svn_username, "numly" 
set :server, '73s.org'
set :svnserver, 'vouchor.svnrepository.com'
set :application, '73s'
set :applicationdir, '73s' 
set :repository, "http://#{svnserver}/svn/#{application}/trunk" 
role :web, server
role :app, server
role :db,  server, :primary => true

ssh_options[:paranoid] = false 

set :deploy_to, "/home/#{user}/#{applicationdir}" 

task :restart, :roles => :app do
end

task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
  run "chmod 755 #{release_path}/emailsummary.sh" 
  run "chmod 755 #{release_path}/aprsfeed.sh" 
end