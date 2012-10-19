#!/usr/bin/ruby
##
# Quick script to touch metarepo
# wget -O /dev/null http://keg.dev.uswest.hpcloud.net:8080/job/cloud_stream/build?token=cloud_stream
require 'rubygems'
require 'pp'
require 'json'
require 'chef'

ChefServerUrl = "http://rndc-chef-server.ops.uswest.hpcloud.net:4000"
puts "Updating role..."

version = `grep 'Version =' rails/config/environment.rb | cut -f2 -d\\" | sed 's/^v//'`.chomp()
#puts "Version: %s" % version
role_name = "MetaRepo_Application"
package_name = "metarepo"

## Init the new connection
conn = Chef::REST.new( ChefServerUrl,"krogerb","./dev_rdc_aw1_az1.key" )
role = conn.get_rest( "/roles/%s" % role_name )

role.default_attributes["package_version"] = version
#pp role.default_attributes
conn.put_rest( "/roles/%s" % role_name, role )

puts "Done updating role."

nodes = conn.get_rest( "/search/node?q=role:%s" % role_name )

#pp nodes.count
nodes["rows"].each do |node|
  puts "Node: %s" % node.ipaddress
  cmd_ssh = "ssh -i id_rsa krogerb@%s \"sudo chef-client\"" % node.ipaddress
  system( cmd_ssh )
end

puts "Done."
