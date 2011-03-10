#
# Author::  Toni Grigoriu (<toni@grigoriu.ro>)
# Cookbook Name:: modman
# Recipe:: default
#
# Copyright 2011, Toni Grigoriu
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

unless node[:platform] == "ubuntu"
  Chef::Log.warn("This recipe is only available for Ubuntu systems.")
  return
end

remote_file "#{Chef::Config[:file_cache_path]}/modman" do
  checksum node[:modman][:checksum]
  source "http://module-manager.googlecode.com/svn/trunk/modman"
  mode "0755"
end

execute "install-modman" do
  cwd "/usr/local/bin"
  command "cp -pR #{Chef::Config[:file_cache_path]}/modman ."
end
