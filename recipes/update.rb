#
# Cookbook Name:: my_server_setup
# Recipe:: update
#
# Copyright 2015, Chef Demo LLC
#
# All rights reserved - Do Not Redistribute
#

# Update package lists
execute 'apt-get-update' do
  command 'apt-get -y update'
  ignore_failure true
  action :run
end

# Do not upgrade grub-pc
execute 'apt-mark-hold-grub' do
  command 'apt-mark hold grub-pc'
  action :run
  ignore_failure true
end

# Upgrade everything, except for grub-pc
execute 'apt-get-upgrade' do
  command 'apt-get -y upgrade'
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  action :run
  notifies :run, 'execute[apt-get-autoremove]', :immediately
  notifies :run, 'execute[apt-get-autoclean]', :immediately
end

# Unhold grub-pc
execute 'apt-mark-unhold-grub' do
  command 'apt-mark unhold grub-pc'
  action :run
  ignore_failure true
end

# Remove packages that are no longer needed for dependencies
execute 'apt-get-autoremove' do
  command 'apt-get -y autoremove'
  action :nothing
end


# Remove .deb files for packages no longer on your system
execute 'apt-get-autoclean' do
  command 'apt-get -y autoclean'
  action :nothing
end

