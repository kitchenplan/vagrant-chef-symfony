include_recipe "apache2::default"

apache_module "rewrite"

template "/etc/apache2/sites-available/project" do
    source "project.erb"
    mode "0755"
    notifies :restart, "service[apache2]"
end

apache_site "project" do
  enable true
  notifies :restart, "service[apache2]"
end
