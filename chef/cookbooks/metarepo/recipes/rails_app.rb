##
# Cookbook Name:: template
# Recipe:: rails_app
#
# Copyright 2012, HPCS
#
# All rights reserved - Do Not Redistribute
#
#node[:project_name] = "sasha"
project_name = "sasha"

service "apache2" do
	action [ :enable, :start ]
	supports :status => true, :restart => true, :reload => true
end

directory "/var/webapps/%s" % project_name do
  mode "0775"
  owner "www-data"
  group project_name
end

link "/var/www/%s" % project_name do
	to "/var/webapps/%s/public" % project_name
	notifies :restart, "service[apache2]"
end

## Enable apache mods
["ssl","rewrite","passenger"].each do |mod_name|
	execute "enable-apache-%s" % mod_name do
		action :run
		command "a2enmod %s" % mod_name
		creates "/etc/apache2/mods-enabled/%s.load" % mod_name
		notifies :restart, "service[apache2]"
	end
end

#apache_vhost project_name do
#end

#template "/etc/apache2/sites-available/.%s." % project_name do
	#mode "0644"
	#owner "root"
	#group "root"
	#source "apache2/vhost.erb"
	#notifies :restart, "service[apache2]"
#end

#execute "enable-%s-site" % project_name do
  #action :run
  #command "a2ensite %s" % project_name
  #creates "/etc/apache2/sites-enabled/%s" % project_name
  #notifies :restart, "service[apache2]"
#end

