#
# Author::  Toni Grigoriu (<toni@grigoriu.ro>)
# Cookbook Name:: magetool
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

bash "pear-discover-channel-zf" do
  user "root"
  code <<-EOH
    pear channel-discover pear.zfcampus.org
    pear channel-discover pear.magetool.co.uk
  EOH
  not_if "pear list-channels |grep zfcampus"
end

bash "pear-discover-channel-magetool" do
  user "root"
  code <<-EOH
    pear channel-discover pear.magetool.co.uk 
  EOH
  not_if "pear list-channels |grep magetool"
end

bash "pear-install-magetool" do
  user "root"
  code <<-EOH
    pear install magetool/MageTool-beta
  EOH
  not_if "pear info magetool/MageTool-beta"
end

cookbook_file "/home/vagrant/.zf.ini" do
  source "zf.ini"
  mode 0644
  owner "vagrant"
  group "vagrant"
end
