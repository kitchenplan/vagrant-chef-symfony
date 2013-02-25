execute "add-mysql-user-sandbox" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"GRANT ALL PRIVILEGES ON #{node['mysql']['database']}.* TO #{node['mysql']['user']}@localhost IDENTIFIED BY '#{node['mysql']['password']}'\""
    action :run
    only_if { `/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"SELECT COUNT(*) FROM user where User='#{node['mysql']['user']}' and Host = 'localhost'"`.to_i == 0 }
end

execute "flush privileges" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"flush privileges;\""
    action :run
end

execute "delete database" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"drop database IF EXISTS #{node['mysql']['database']}\""
    action :run
end

execute "create database" do
    command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"create database #{node['mysql']['database']} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci\""
    action :run
end
