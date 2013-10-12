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

bash "clenup apt repo list" do
  code "rm /etc/apt/sources.list.d/*.chef* || echo 'no bad repo files found'"
  notifies :run, 'execute[apt-get update]', :immediately
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


# Install features.

features = node[:identity_server][:features][:list]
features.each do |f|
  log "Install #{f} feature"
  # Prepare a directory
  directory "/opt/wso2is/repository/components/features/#{f}" do
    owner "root"
    group "root"
    mode 00755
    action :create
  end
  # download jar
  remote_file "/tmp/#{f}.jar" do
    source "#{node[:identity_server][:features][:repository]}/features/#{f}.jar"
    action :create
  end
  # unzip jar
  bash "unpack #{f} feature" do
    code "cd /opt/wso2is/repository/components/features/#{f} && jar -xvf /tmp/#{f}.jar"
  end
end

##TODO: start the rerver

rightscale_marker :end
