##
# Cookbook Name:: lock_pass
# Recipe:: mysql
#
# The basic idea here is to create a small, portable recipe for creating the mysql rights and tables
#		for the application.
#
# Copyright 2012, HPCS
# All rights reserved - Do Not Redistribute
#

project_name = node.default[:project_name]
project_role_name = "Bartender"

## Application specific data from edb.
app_secure_data = get_encrypted_bag( project_name,"app" )

## Search for the application nodes
#app_nodes = search( :node,"run_list:role\\[%sApplication\\]" % "AccessAPI" )  ## Using AccessAPI resources.
app_nodes = search( :node,"run_list:role\\[%s_Application\\]" % project_role_name ) ## Using resources dedicated to this service.

application_sql project_name do
	nodes app_nodes
	db_config app_secure_data["database"]
end

