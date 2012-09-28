##
# Cookbook Name:: bartender
# Recipe:: apache
#
# Creates the self-signed cert and creates the service.
#
# Copyright 2012, HPCS
# All rights reserved - Do Not Redistribute
#

# Generate a self-signed SSL certificate for Apache
bash "Create SSL Certificates" do
  cwd "/etc/ssl/private"
  code <<-EOH
umask 077
openssl genrsa 2048 > server.key.pem
openssl req -subj "/C=US/ST=NV/L=Las Vegas/O=Hewlett-Packard/OU=Cloud/CN=#{node.name}" -new -x509 -nodes -sha1 -days 3650 -key server.key.pem > server.crt.pem
cat server.key.pem server.crt.pem > server.pem
EOH
  not_if { File.exists?("/etc/ssl/private/server.pem") }
  notifies :restart, "service[apache2]"
end

package "apache2"

service "apache2" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
