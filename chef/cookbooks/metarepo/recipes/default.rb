##
# sasha::default
#
# Copyright 2012, HPCS
#
# All rights reserved - Do Not Redistribute
project_name = "sasha"

#cookbook_file "/home/%s/.chef/%s_chef.pem" % [project_name,project_name] do
  #mode "0644"
  #owner project_name
  #group project_name
  #source "%s_chef.pem" % project_name
#end

service "apache2" do
	action [ :enable, :start ]
	supports :status => true, :restart => true, :reload => true
end

directory "/var/webapps/%s" % project_name do
  mode "0775"
  owner "www-data"
  group "www-data"
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

template "/etc/apache2/sites-available/%s" % project_name do
  mode "0644"
  owner "root"
  group "root"
  source "apache2/vhost.erb"
  notifies :restart, "service[apache2]"
  variables({
    :port => 443,
    :use_ssl => true,
    :project_name => project_name
  })
end

execute "enable-%s-site" % project_name do
  action :run
  command "a2ensite %s" % project_name
  creates "/etc/apache2/sites-enabled/%s" % project_name
  notifies :restart, "service[apache2]"
end

execute "disable default" do
  action :run
  command "a2dissite default"
  #creates "/etc/apache2/sites-enabled/%s" % project_name
  notifies :restart, "service[apache2]"
end


## Adding a custom gem file so we can use gem inabox
cookbook_file "/root/.gemrc" do
  mode "0755"
  owner "root"
  group "root"
  source "gemrc"
end

## Ensure tha this gem exists.
execute "update gem" do
  action :run
  command "gem update"
  only_if "gem list encoded_api --remote |grep encoded_api"
end

["encoded_api_client","accessapi","lock_pass"].each do |package_name|
  gem_package package_name do
    action :install
  end
end

