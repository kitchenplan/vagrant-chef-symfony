composer "/usr/local/bin" do
  owner "root" # optional
  action [:install, :update]
end

composer_project "/vagrant" do
 action [:install]
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
