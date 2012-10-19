#!/usr/bin/ruby
##
# Quick script to touch metarepo
# wget -O /dev/null http://keg.dev.uswest.hpcloud.net:8080/job/cloud_stream/build?token=cloud_stream
require 'rubygems'
require 'pp'
require 'json'
require 'rest-client'

MetaRepoUrl = "https://metarepo.rndc.aw1.hpcloud.net"
puts "Updating metarepo at: %s" % MetaRepoUrl

version = `grep 'Version =' rails/config/environment.rb | cut -f2 -d\\" | sed 's/^v//'`.chomp()
#puts "Version: %s" % version
package_name = "metarepo"

conn ||= RestClient::Resource.new( MetaRepoUrl )
upstream = {
  'name' => 'jenkins_ops_auto',
  'type' => 'apt',
  'path' => 'jenkins_ops_auto'
}
job = JSON::parse( conn["/upstream/%s" % upstream['name']].put( upstream.to_json,{ 'Content-Type' => 'application/json' }) )

if(job.has_key?( 'job_id' ) && job['job_id'] != '')
  checking = false
  while( checking == true )
    res = JSON::parse( conn["/job/%s/%s" % [job['job_class'],job['job_id']]].get({ 'Content-Type' => 'application/json' }) )
    pp res
    checking = false if(res['finished_at'] != nil)
    sleep 1
  end

  ## Now let's bind this version to the appropriate repo.
  
  ## Get the package shasum
  q_string = { 'name' => package_name, 'version' => version }.map{|k,v| "%s=%s" % [k,v] }.join( "&" )
  #puts "QString: %s" % q_string
  package = JSON::parse( conn["/package/search?%s" % q_string].get({ 'Content-Type' => 'application/json' }) )

  ## Get the repo
  current_repo_packages = JSON::parse( conn["/repo/ops_auto/packages"].get )
  new_package_list = { package.keys[0] => true }

  current_repo_packages.each do |sum,package|
    new_package_list[sum] = true
  end
  job = JSON::parse( conn["/repo/ops_auto/packages"].put( new_package_list.to_json ) )

  checking = true
  while( checking == true )
    res = JSON::parse( conn["/job/%s/%s" % [job['job_class'],job['job_id']]].get({ 'Content-Type' => 'application/json' }) )
    checking = false if(res['finished_at'] != nil)
    sleep 1
  end

  puts "Update complete."
end

