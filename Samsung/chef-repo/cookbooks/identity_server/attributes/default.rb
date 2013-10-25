#
# Cookbook Name:: identity_server
# Attribute:: default
#
# Copyright 2013, ClearScale
#
# All rights reserved - Do Not Redistribute
#

override[:identity_server][:deps] = ["default-jdk", "default-jre", "ant", "unzip", "mysql-client"]

override[:identity_server][:carbon][:features] = ["org.wso2.carbon.cassandra-jdbc-1.1.1.server_4.2.0"]
override[:identity_server][:carbon][:plugins] = ["cassandra-jdbc_1.1.1.wso2v1"]
override[:identity_server][:carbon][:libs] = ["mysql-connector-java-5.1.16"]

default[:identity_server][:mysql][:host] = ""
default[:identity_server][:mysql][:port] = ""
default[:identity_server][:mysql][:dbname] = ""
default[:identity_server][:mysql][:username] = ""
default[:identity_server][:mysql][:password] = ""

default[:identity_server][:cassandra][:host] = ""
default[:identity_server][:cassandra][:port] = ""
default[:identity_server][:cassandra][:keyspace] = ""

if node[:cloud]
  default[:identity_server][:ip] = node[:cloud][:private_ips][0]
else
  default[:identity_server][:ip] = "127.0.0.1"
end
