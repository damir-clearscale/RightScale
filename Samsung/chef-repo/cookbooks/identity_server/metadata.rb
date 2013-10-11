maintainer       "ClearScale"
maintainer_email "taras.kotov@clearscale.net"
license          "All rights reserved"
description      "Installs/Configures WSO2 Identity Sever"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends "rightscale"

recipe "identity_server::default", "Install and configure WSO2 Identity Server"
recipe "identity_server::cassandra", "Install Apache Cassandra from package"

attribute "identity_server/repo_path",
  :description  => "Path to repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default"],
  :type         => "string",
  :display_name => "Path to repository with WSO2 Identity Server package",
  :required     => "recommended",
  :default      => "http://54.215.135.186"

attribute "identity_server/repo_dist",
  :description  => "Distribution in repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default"],
  :type         => "string",
  :display_name => "Distribution in repository with WSO2 Identity Server package",
  :required     => "recommended",
  :default      => "debian/"

attribute "identity_server/repo_comp",
  :description  => "Components of repository with WSO2 Identity Server package",
  :recipes      => ["identity_server::default"],
  :type         => "array",
  :display_name => "Components of repository with WSO2 Identity Server package",
  :required     => "optional"

attribute "identity_server/carbon/hostname",
  :description  => "Host name or IP address of the machine hosting this server, e.g. www.wso2.org, 192.168.1.10.
    This is will become part of the End Point Reference of the services deployed on this server instance.",
  :recipes      => ["identity_server::default"],
  :type         => "string",
  :display_name => "Host name or IP address of the machine hosting this server.",
  :required     => "optional",
  :default      => "localhost"
