#
# Cookbook Name:: magento
# Recipe:: default
#
# Based on original code from https://github.com/opscode/cookbooks/tree/master/wordpress
#
# Copyright 2009-2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


### Apache ###
include_recipe "apache2"

if node.has_key?("ec2")
  server_fqdn = node.ec2.public_hostname
else
  server_fqdn = node.fqdn
end

remote_file "#{Chef::Config[:file_cache_path]}/magento-#{node[:magento][:version]}.tar.gz" do
  checksum node[:magento][:checksum]
  source "http://www.magentocommerce.com/downloads/assets/#{node[:magento][:version]}/magento-#{node[:magento][:version]}.tar.gz"
  mode "0644"
end

directory "#{node[:magento][:dir]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "untar-magento" do
  cwd node[:magento][:dir]
  command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/wordpress-#{node[:magento][:version]}.tar.gz"
  #creates "#{node[:wordpress][:dir]}/wp-settings.php"
end

execute "mysql-install-magento-privileges" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/mysql/magento-grants.sql"
  action :nothing
end


### MySQL ###
include_recipe "mysql::server"
require 'rubygems'
Gem.clear_paths
require 'mysql'

template "/etc/mysql/magento-grants.sql" do
  path "/etc/mysql/magento-grants.sql"
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node[:magento][:db][:user],
    :password => node[:magento][:db][:password],
    :database => node[:magento][:db][:database]
  )
  notifies :run, resources(:execute => "mysql-install-magento-privileges"), :immediately
end

execute "create #{node[:magento][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:magento][:db][:database]}"
  not_if do
    m = Mysql.new("localhost", "root", node[:mysql][:server_root_password])
    m.list_dbs.include?(node[:magento][:db][:database])
  end
end

# save node data after writing the MYSQL root password, so that a failed chef-client run that gets 
# this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
ruby_block "save node data" do
  block do
    node.save
  end
  action :create
end


### PHP ###
include_recipe %w{php::php5 php::module_apc php::module_curl php::module_mcrypt}

execute "magento-install" do
  command "#{Chef::Config[:file_cache_path]}/install"
  action :nothing
end

template "#{Chef::Config[:file_cache_path]}/install" do
  source "install.erb"
  owner "root"
  group "root"
  mode "0744"
  variables(
    :mage_dir        => node[:magento][:dir],
    :database        => node[:magento][:db][:database],
    :user            => node[:magento][:db][:user],
    :password        => node[:magenito][:db][:password],
    :server_name     => server_fqdn,
    :enc_key         => node[:magento][:enc_key]
  )
  notifies :run, resources(:execute => "magento-install"), :immediately
end

web_app "magento" do
  template "magento.conf.erb"
  docroot "#{node[:magento][:dir]}"
  server_name server_fqdn
  server_aliases node.fqdn
end
