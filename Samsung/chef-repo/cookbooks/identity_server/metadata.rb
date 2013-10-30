maintainer       "ClearScale"
maintainer_email "taras.kotov@clearscale.net"
license          "All rights reserved"
description      "Installs/Configures WSO2 Identity Sever"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends "rightscale"
depends "database"

recipe "identity_server::default", "Install and configure WSO2 Identity Server (standalone)"
recipe "identity_server::cluster", "Install and configure WSO2 Identity Cluster"
recipe "identity_server::dbinit", "Init shared DB"

attribute "identity_server/repo_path",
  :description  => "Path to repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Path to repository with WSO2 Identity Server package",
  :required     => "recommended",
  :default      => "http://54.215.135.186"

attribute "identity_server/repo_dist",
  :description  => "Distribution in repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Distribution in repository with WSO2 Identity Server package",
  :required     => "recommended",
  :default      => "debian/"

attribute "identity_server/repo_comp",
  :description  => "Components of repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "array",
  :display_name => "Components of repository with WSO2 Identity Server package",
  :required     => "optional"

attribute "identity_server/carbon/hostname",
  :description  => "Host name or IP address of the machine hosting this server, e.g. www.wso2.org, 192.168.1.10.
    This is will become part of the End Point Reference of the services deployed on this server instance.",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Host name or IP address of the machine hosting this server.",
  :required     => "optional",
  :default      => "localhost"


attribute "identity_server/mysql/host",
  :description  => "Host name or IP address of MySQL DB for central registry cluster database",
  :recipes      => ["identity_server::cluster", "identity_server::dbinit"],
  :type         => "string",
  :display_name => "Host name or IP address of MySQL DB for central registry cluster database",
  :required     => "optional",
  :default      => "localhost"

attribute "identity_server/mysql/port",
  :description  => "Port of MySQL DB for central registry cluster database",
  :recipes      => ["identity_server::cluster", "identity_server::dbinit"],
  :type         => "string",
  :display_name => "Port of MySQL DB for central registry cluster database",
  :required     => "optional",
  :default      => "3306"

attribute "identity_server/mysql/dbname",
  :description  => "Database name in MySQL for central registry cluster database",
  :recipes      => ["identity_server::cluster", "identity_server::dbinit"],
  :type         => "string",
  :display_name => "Database name in MySQL for central registry cluster database",
  :required     => "optional"

attribute "identity_server/mysql/username",
  :description  => "Username in MySQL for central registry cluster database",
  :recipes      => ["identity_server::cluster", "identity_server::dbinit"],
  :type         => "string",
  :display_name => "Username in MySQL for central registry cluster database",
  :required     => "optional"

attribute "identity_server/mysql/password",
  :description  => "Password for central registry cluster database in MySQL",
  :recipes      => ["identity_server::cluster", "identity_server::dbinit"],
  :type         => "string",
  :display_name => "Password for central registry cluster database in MySQL",
  :required     => "optional"

attribute "identity_server/cassandra/host",
  :description  => "Host name or IP address of Cassandra DB for CassandraUserStoreManager",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Host name or IP address of Cassandra DB for CassandraUserStoreManager",
  :required     => "optional",
  :default      => "localhost"

attribute "identity_server/cassandra/port",
  :description  => "Port of Cassandra DB for CassandraUserStoreManager",
  :recipes      => ["identity_server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Port of Cassandra DB for CassandraUserStoreManager",
  :required     => "optional",
  :default      => "9160"

attribute "identity_server/cassandra/keyspace",
  :description  => "Keyspace in Cassandra DB for CassandraUserStoreManager",
  :recipes      => ["identity_>server::default", "identity_server::cluster"],
  :type         => "string",
  :display_name => "Keyspace in Cassandra DB for CassandraUserStoreManager",
  :required     => "required"
