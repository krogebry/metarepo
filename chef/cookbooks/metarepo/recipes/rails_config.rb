##
# Service side cookbook.
#
# Cookbook Name:: sasha
# Recipe:: default
#
# Copyright 2012, HPCloudServices
# @author Bryan Kroger ( bryan.kroger@hp.com )



## Load the encrypted secret data.
begin
  ## Note: this data should *NEVER* be stored on the node.
  #chef_certs = get_encrypted_bag( "sasha","chef_certs" )
  ad_secure_data = get_encrypted_bag( "sasha","active_directory" )
  app_secure_data = get_encrypted_bag( "sasha","app" )
  project_name = "sasha"

rescue => e
  Chef::Log.fatal( "sasha::default Unable to get encrypted data bag: %s" % e )
  Chef::Log.fatal( e.backtrace.join( "\n" ) )

end



## Create the db config file.
begin
  ## Find the mysql master node.
  mysql_master_nodes = search( :node,"run_list:role\\[AccessAPIMySQLMaster\\]" )

  template "/var/webapps/sasha/config/database.yml" do
    mode "0644"
    owner "www-data"
    group "www-data"
    source "database.yml.erb"
    notifies :restart, "service[apache2]"
    variables(
      :name => app_secure_data["database"]["name"],
      :username => app_secure_data["database"]["username"],
      :password => app_secure_data["database"]["password"],
		  :hostname => mysql_master_nodes.first["ipaddress"]
    )
  end

rescue => e
  Chef::Log.fatal( "sasha::default Failed to process database config: %s" % e )
  Chef::Log.fatal(e.backtrace.join( "\n" ))

end



## Create the environment-specific file.
begin
  ## Look for the memcache nodes.
  memc_nodes = search( :node,"run_list:role\\[AccessAPICache\\]" )

  directory "/var/webapps/sasha/config/environments" do
    mode "0755"
    owner "www-data"
    group "www-data"
	  action :create
	  recursive true
  end

  ## Create the api client configuration files.
  app_secure_data["api_clients"].each do |name,cfg_client|
    Chef::Log.fatal( "sasha::rails_config::api_client: %s" % cfg_client.inspect )
    api_client name do
      url cfg_client["url"]
      client_id cfg_client["client_id"]
      secret_key cfg_client["secret_key"]
      public_key cfg_client["key"]
      client_name cfg_client["client_name"]
      fs_config_root "/var/webapps/%s/config" % project_name
    end
  end

  template "/var/webapps/sasha/config/environments/production.rb" do
    mode "0755"
    owner "www-data"
    group "www-data"
    source "production.rb.erb"
    notifies :restart, "service[apache2]"
    variables(
		  :path => "sasha",
      :schema => "https",
      :hostname => node[:ipaddress],
		  :memc_nodes => memc_nodes
    )
  end

rescue => e
  Chef::Log.fatal( "sasha::default Failed to process environment config: %s" % e )
  Chef::Log.fatal(e.backtrace.join( "\n" ))

end



## ActiveDirectory connector
begin
  ## This is a bit messy, but eventually we should come up with a better way of doing this.
  #cmd_get_ad_hosts = "dig -t SRV _ldap._tcp.dc._msdcs.hpcloud.ms |grep \"^_ldap\"|awk '{print $8}'|sed 's/\.$//'"
  #ad_hosts = `#{cmd_get_ad_hosts}`.split()
  ad_hosts = [ "aw2clouddc02.hpcloud.ms", "aw2clouddc01.hpcloud.ms", "ae1clouddc03.hpcloud.ms", "ae1clouddc01.hpcloud.ms", "aw2clouddc03.hpcloud.ms" ]
  #Chef::Log.debug( "sasha:default:ADHosts: %s" % ad_hosts.inspect )

  template "/var/webapps/sasha/config/ldap.yml" do
    mode "0644"
    owner "www-data"
    group "www-data"
    source "ldap.yml.erb"
    notifies :restart, "service[apache2]"
    variables(
      :port => ad_secure_data["port"],
      :ad_hosts => ad_hosts,
      :search_base => ad_secure_data["search_base"],
      :ldap_read_pw => ad_secure_data["ldap_read_pw"],
      :ldap_read_dn => ad_secure_data["ldap_read_dn"]
    )
  end
 
rescue => e
  Chef::Log.fatal( "sasha::default:ad_config Failed to create ldap config: %s" % e )
  Chef::Log.fatal(e.backtrace.join( "\n" ))

end


