##
# Cookbook Name:: bartender
# Recipe:: custom_ruby
#
# This is a mess.
#		* nodejs is required by the rails 3.x engine.  I personally think this is a horrible mistake by the rails community.  NodeJS shouldn't be required
#			just so I can run a rails application.
#
# Copyright 2012, HPCS
# All rights reserved - Do Not Redistribute
#

project_name = node.default[:project_name]

## Packages required to build custom passenger mod for apache
%w(make libcurl4-openssl-dev libssl-dev apache2-prefork-dev libapr1-dev g++ libaprutil1-dev libxml2-dev libxslt1-dev nodejs).each do |p|
	package p
end
%w(libapache2-mod-passenger ruby1.9.1-full rubygems1.8).each do |p|
  package p
end

execute "unlink old ruby" do
	action :run
	command "unlink /usr/bin/ruby ; ln -s /usr/bin/ruby1.9.1 /usr/bin/ruby"
	only_if { "readlink /usr/bin/ruby|grep ruby1.8" || !File.exists?( "/usr/bin/ruby" ) }
end

execute "unlink old gem" do
	action :run
	command "unlink /usr/bin/gem ; ln -s /usr/bin/gem1.9.1 /usr/bin/gem"
	only_if { File.exists?( "/usr/bin/gem" ) && "readlink /usr/bin/gem|grep alternatives" }
end

execute "Upgrade gem" do
	action :run
	command "export REALLY_GEM_UPDATE_SYSTEM=1 ; gem update --system"
	only_if "gem -v|grep 1.3" 
end

## Custom passenger install
# gem install passenger
#gem_package "passenger"
%w(passenger bundler ruby-shadow).each do |package_name|
	execute "Install %s" % package_name do
		action :run
		command "gem install %s" % package_name
		not_if "gem list %s|grep %s" % [package_name,package_name]
	end
end

## TODO: Make the pain stop and put this chunk of ugly out of it's missery.
execute "Compile passenger apache moduule" do
	action :run
	#command "/usr/lib/ruby/gems/1.9.1/gems/passenger-3.0.17/bin/passenger-install-apache2-module -a"
	command "/usr/local/bin/passenger-install-apache2-module -a"
	#not_if File.exists?( "/usr/lib/ruby/gems/1.9.1/gems/passenger-3.0.17/ext/apache2/mod_passenger.so" ).to_s
	not_if File.exists?( "/usr/lib/apache2/modules/mod_passenger.so" ).to_s
end

link "/var/lib/gems/1.9.1/bin/bundle" do
	to "/usr/bin/bundle"
	not_if {!File.exists?( "/usr/bin/bundle" )}
end

## Configure the apache mods.
cookbook_file "/etc/apache2/mods-available/passenger.conf" do
  mode "0644"
  owner "root"
  group "root"
  source "apache2/passenger.conf"
  notifies :restart, "service[apache2]"
end

cookbook_file "/etc/apache2/mods-available/passenger.load" do
  mode "0644"
  owner "root"
  group "root"
  source "apache2/passenger.load"
  notifies :restart, "service[apache2]"
end
