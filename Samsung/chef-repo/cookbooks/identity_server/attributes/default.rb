#
# Cookbook Name:: identity_server
# Attribute:: default
#
# Copyright 2013, ClearScale
#
# All rights reserved - Do Not Redistribute
#

override[:identity_server][:deps] = ["default-jdk", "default-jre", "ant", "unzip"]


override[:identity_server][:carbon][:repository] = "http://dist.wso2.org/p2/carbon/releases/4.2.0"
override[:identity_server][:carbon][:features] = ["org.wso2.carbon.cassandra-jdbc-1.1.1.server_4.2.0"]
override[:identity_server][:carbon][:plugins] = ["cassandra-jdbc_1.1.1.wso2v1"]
