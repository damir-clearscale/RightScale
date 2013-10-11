#
# Cookbook Name:: identity_server
# Recipe:: default
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin


include_recipe "apt"

apt_repository "wso2" do
  uri node[:identity_server][:repo_path]
  distribution node[:identity_server][:repo_dist]
  components node[:identity_server][:repo_comp]
  deb_src false
#  keyserver 'keyserver.ubuntu.com'
#  key '4F4EA0AAE5267A6C'
end

packages = node[:identity_server][:deps]
packages.each do |p|
  package p do
    action :install
    ignore_failure true
  end
end

apt_package "wso2is" do
  action :install
  options "--force-yes"
end

template "/opt/wso2is/repository/conf/carbon.xml" do
  source "carbon.xml.erb"
  mode 00644
  action :create
  #notifies :restart, "service name"
  ignore_failure true
end

##TODO: start the rerver

rightscale_marker :end
