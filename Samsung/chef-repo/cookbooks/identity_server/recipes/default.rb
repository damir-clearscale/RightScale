#
# Cookbook Name:: identity_server
# Recipe:: default
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

file "/etc/apt/sources.list.d/samsung.list" do
  source "samsung.list"
  mode "644"
  owner "root"
  group "root"
end

execute "update repo list" do
  command "apt-get update"
end

package "wso2is" do
  action :install
end

rightscale_marker :end
