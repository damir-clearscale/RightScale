#
# Cookbook Name:: identity_server
# Recipe:: cluster
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
  notifies :restart, "service[wso2is]"
end
template "/opt/wso2is/repository/conf/user-mgt.xml" do
  source "user-mgt.xml.erb"
  mode 00644
  action :create
  notifies :restart, "service[wso2is]"
end


# Install features.

features = node[:identity_server][:carbon][:features]
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
  cookbook_file "/tmp/#{f}.jar" do
    source "#{f}.jar"
    action :create
  end
  # unzip jar
  bash "unpack #{f} feature" do
    code "cd /opt/wso2is/repository/components/features/#{f} && jar -xvf /tmp/#{f}.jar"
  end
end

plugins = node[:identity_server][:carbon][:plugins]
plugins.each do |p|
  log "Install #{p} plugin"
  # download jar
  cookbook_file "/opt/wso2is/repository/components/plugins/#{p}.jar" do
    source "#{p}.jar"
    action :create
  end
end

libs = node[:identity_server][:carbon][:libs]
libs.each do |l|
  log "Install #{l} library"
  # download jar
  cookbook_file "/opt/wso2is/repository/components/lib/#{l}.jar" do
    source "#{l}.jar"
    action :create
  end
end

# Obtain information about all nodes of the cluster by querying for its tags
r = rightscale_server_collection "node_X" do
  tags "wso2is:node=*"
  action :nothing
end
r.run_action(:load)

node1_ip = ""
node_ips = ["#{node[:identity_server][:ip]}"]
r = ruby_block "find nodes" do
  block do
    node[:server_collection]["node_X"].each do |id, tags|
      node_ip_tag = tags.detect { |u| u =~ /wso2is:listen_ip/ }
      node_ip = node_ip_tag.split(/=/, 2).last.chomp
      if node_ip==node[:identity_server][:ip] then
        Chef::Log.info "Node IP (me): #{node_ip}"
      else
        node_ips << node_ip
        Chef::Log.info "Node IP: #{node_ip}"
      end

      # Obtain information about First node of the cluster by querying for its tags: http://docs.wso2.org/display/Cluster/Clustering+Identity+Server
      node_number_tag = tags.detect { |u| u =~ /wso2is:node/ }
      node_number = node_number_tag.split(/=/, 2).last.chomp
      if node_number=="1" then
        node1_ip = node_ip
        Chef::Log.info "Found Node 1 IP: #{node1_ip}"
      end
    end
  end
end
r.run_action(:create)


# Is node 1 found? Are we not node 1?
if node1_ip.strip.length>0 && node1_ip!=node[:identity_server][:ip] then
  # yes and yes, and following is a second node
  template "/opt/wso2is/repository/conf/registry.xml" do
    source "registry.xml.erb"
    mode 00644
    action :create
    notifies :restart, "service[wso2is]"
  end

  right_link_tag "wso2is:node=2"
  Chef::Log.info "Process node 2"
else
  # no, lets configure the first node

  # Do we have node 1?
  unless node1_ip.strip.length>0 then
    # no, this this the first time we start the recipe. Lets prepare the DB
    include_recipe "identity_server::dbinit"
  end

  right_link_tag "wso2is:node=1"
  Chef::Log.info "Process node 1"
end
right_link_tag "wso2is:listen_ip=#{node[:identity_server][:ip]}"

Chef::Log.info "Create the cluster"

template "/opt/wso2is/repository/conf/datasources/master-datasources.xml" do
  source "master-datasources.xml.erb"
  mode 00644
  action :create
  notifies :restart, "service[wso2is]"
end


template "/opt/wso2is/repository/conf/axis2/axis2.xml" do
  source "axis2.xml.erb"
  mode 00644
  action :create
  variables(
    :node_ips => node_ips )
  notifies :restart, "service[wso2is]"
end

Chef::Log.info "Start script"

template "/etc/init.d/wso2is" do
  source "init.d_wso2is.erb"
  owner "root"
  mode 00755
end

#template "/etc/default/wso2is" do
#  source "wso2is.erb"
#  owner "root"
#  mode 00644
#  action :create
#  notifies :restart, "service[wso2is]"
#end

Chef::Log.info "Enable wso2is service"

service "wso2is" do
  supports :restart => true, :status => true
  action [:enable, :start]
end

rightscale_marker :end
