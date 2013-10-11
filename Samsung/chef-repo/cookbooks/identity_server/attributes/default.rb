#
# Cookbook Name:: identity_server
# Attribute:: default
#
# Copyright 2013, ClearScale
#
# All rights reserved - Do Not Redistribute
#

override[:identity_server][:deps] = ["default-jre", "ant"]
