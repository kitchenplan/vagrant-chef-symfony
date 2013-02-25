include_recipe "symfony::update"
include_recipe "symfony::apache"
include_recipe "symfony::php"
include_recipe "git"
include_recipe "mysql::server"
include_recipe "java"


=begin
package "build-essential"
package "libmagick++-dev"

template "/etc/apache2/sites-available/sandbox" do
    source "sandbox.erb"
    mode "0755"
    notifies :restart, "service[apache2]"
end

apache_site "sandbox" do
  enable true
  notifies :restart, "service[apache2]"
end

composer "/usr/local/bin" do
  owner "root" # optional
  action [:install]
end

composer_project "/vagrant" do
 action [:update]
end

symfony2_console "assets install" do
  action :cmd
  command "assets:install"
  path "/vagrant"
end

symfony2_console "assetic dump" do
  action :cmd
  command "assetic:dump"
  path "/vagrant"
end

execute "add-mysql-user-sandbox" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"GRANT ALL PRIVILEGES ON sandbox.* TO sandbox@localhost IDENTIFIED BY 'sandbox'\""
    action :run
    only_if { `/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"SELECT COUNT(*) FROM user where User='sandbox' and Host = 'localhost'"`.to_i == 0 }
end

execute "flush privileges" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"flush privileges;\""
    action :run
end

execute "delete database" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"drop database IF EXISTS sandbox\""
    action :run
end

execute "create database" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"create database sandbox DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci\""
    action :run
end

symfony2_console "doctrine schema create" do
  action :cmd
  command "doctrine:schema:create"
  path "/vagrant"
end

execute "full reload" do
    command "./fullreload"
    cwd "/vagrant"
    user "vagrant"
    action :run
    only_if { File.exists?('/vagrant/fullreload') }
end=end

