#
# Cookbook Name:: identity_server
# Recipe:: dbinit
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

# Init MySQL connection

rightscale_marker :begin

sqls = "mysql.sql"

mhost = node[:identity_server][:mysql][:host]
mport = node[:identity_server][:mysql][:port]
mdb = node[:identity_server][:mysql][:dbname]
muser = node[:identity_server][:mysql][:username]
if (mhost.strip.length>0 && mport.strip.length>0 && mdb.strip.length>0 && muser.strip.length>0) then

  mysql_connection_info = {:host => node[:identity_server][:mysql][:host],
                           :port => node[:identity_server][:mysql][:port],
                           :username => node[:identity_server][:mysql][:username],
                           :password => node[:identity_server][:mysql][:password]}

  # Load initial data to the database. Concatenation used because chef caches file content and 2nd and 3rd mysql.sql files will not be loaded if you put them into separate blocks.
  # Do nothing if there are tables and some data in the DB
  mysql_database "#{mdb}" do
    connection mysql_connection_info
    sql { ::File.open("/opt/wso2is/dbscripts/#{sqls}").read +
          ::File.open("/opt/wso2is/dbscripts/identity/#{sqls}").read +
          ::File.open("/opt/wso2is/dbscripts/service-provider/#{sqls}").read }
    action :query
    not_if("/usr/bin/mysql -u#{muser} -p#{node[:identity_server][:mysql][:password]} -h#{mhost} -P#{mport} #{mdb} -e'select * from IDN_BASE_TABLE' |grep 'WSO2 Identity Server'")
  end
end

rightscale_marker :end
