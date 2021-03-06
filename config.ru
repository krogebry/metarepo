#!/usr/bin/env ruby

$: << File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'metarepo'
if File.exists?("/etc/metarepo.rb")
  Metarepo::Config.from_file("/etc/metarepo.rb")
end
Metarepo.connect_db
require 'metarepo/rest_api'
require 'vegas'

run Metarepo::RestAPI
