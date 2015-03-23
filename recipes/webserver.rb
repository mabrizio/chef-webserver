#
# Cookbook Name:: my_server_setup
# Recipe:: webserver
#
# Copyright 2015, Chef Demo LLC
#
# All rights reserved - Do Not Redistribute
#

# Command line web browser
package 'elinks' do
  action :install
end

# Apache
package "apache2" do
  action :install
end

service "apache2" do
    supports :restart => true, :reload => true
    action :enable
end

# PHP
%w(php5 libapache2-mod-php5).each do |software|
    package "#{software}" do
        notifies :restart, 'service[apache2]', :delayed
    end
end

# Remove defualt index page
file "/var/www/index.html" do
  action :delete
end

# Upload new index

template "/var/www/index.php" do
  source "hello_world.php.erb"
  mode   '0755'
  owner  'root'
  group  'root'
  variables({
    node_platform: node.platform,
    node_platform_version: node.platform_version,
    node_env: node.chef_environment

  })
end

