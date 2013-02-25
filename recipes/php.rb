include_recipe "php::default"

package "php5-mysqlnd"
package "php5-mcrypt"
package "php-apc"
package "php5-imagick"
package "php5-cli"
package "php5-gd"
package "php5-memcached"
package "php5-curl"
package "php5-intl"
package "php5-dev"
package "php-pear"

package "libapache2-mod-php5" do
    notifies :restart, "service[apache2]"
end

template "/etc/php5/conf.d/99-kunstmaan.ini" do
    source "phpconfig.erb"
    owner "root"
    mode "0755"
end
