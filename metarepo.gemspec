# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "metarepo"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Jacob"]
  s.date = "2012-09-26"
  s.description = "Takes pacakges, builds repos"
  s.email = "adam@opscode.com"
  s.executables = ["livefire", "metarepo", "metarepo-rest"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/livefire",
    "bin/metarepo",
    "bin/metarepo-rest",
    "lib/metarepo.rb",
    "lib/metarepo/command.rb",
    "lib/metarepo/command/package_list.rb",
    "lib/metarepo/command/package_show.rb",
    "lib/metarepo/command/repo_create.rb",
    "lib/metarepo/command/repo_list.rb",
    "lib/metarepo/command/repo_packages.rb",
    "lib/metarepo/command/repo_show.rb",
    "lib/metarepo/command/repo_sync.rb",
    "lib/metarepo/command/upstream_create.rb",
    "lib/metarepo/command/upstream_list.rb",
    "lib/metarepo/command/upstream_packages.rb",
    "lib/metarepo/command/upstream_show.rb",
    "lib/metarepo/config.rb",
    "lib/metarepo/job/repo_packages.rb",
    "lib/metarepo/job/repo_sync_packages.rb",
    "lib/metarepo/job/upstream_sync_packages.rb",
    "lib/metarepo/log.rb",
    "lib/metarepo/package.rb",
    "lib/metarepo/pool.rb",
    "lib/metarepo/repo.rb",
    "lib/metarepo/rest_api.rb",
    "lib/metarepo/upstream.rb",
    "migrations/001_create_upstreams.rb",
    "migrations/002_create_packages.rb",
    "migrations/003_packages_upstreams.rb",
    "migrations/004_create_repos.rb",
    "migrations/005_packages_repos.rb",
    "migrations/006_add_timestamp_columns.rb",
    "spec/data/at-3.1.10-42.el6.i686.rpm",
    "spec/data/command_per_line",
    "spec/data/libxcb-property1_0.3.6-1build1_amd64.deb",
    "spec/data/upstream/centos/6.0/os/i386/Packages/basesystem-10.0-4.el6.noarch.rpm",
    "spec/data/upstream/centos/6.0/os/i386/Packages/bitmap-fonts-compat-0.3-15.el6.noarch.rpm",
    "spec/data/upstream/debian/dists/stable/main/binary-amd64/Packages.gz",
    "spec/data/upstream/debian/pool/main/2/2vcard/2vcard_0.5-3_all.deb",
    "spec/data/upstream/directory/libxcb-property1_0.3.6-1build1_amd64.deb",
    "spec/data/upstream/directory/nothing_to_see_here",
    "spec/metarepo/config_spec.rb",
    "spec/metarepo/package_spec.rb",
    "spec/metarepo/pool_spec.rb",
    "spec/metarepo/repo_spec.rb",
    "spec/metarepo/rest_api_spec.rb",
    "spec/metarepo/upstream_spec.rb",
    "spec/metarepo_spec.rb",
    "spec/spec_helper.rb",
    "usage/Makefile",
    "usage/make.bat",
    "usage/source/api.rst",
    "usage/source/conf.py",
    "usage/source/index.rst",
    "usage/source/install.rst"
  ]
  s.homepage = "http://github.com/adamhjk/metarepo"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Creates and tracks repositories for many operating systems"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, [">= 3.33.0"])
      s.add_runtime_dependency(%q<pg>, [">= 0"])
      s.add_runtime_dependency(%q<mixlib-config>, [">= 0"])
      s.add_runtime_dependency(%q<mixlib-log>, [">= 0"])
      s.add_runtime_dependency(%q<mixlib-shellout>, [">= 0"])
      s.add_runtime_dependency(%q<mixlib-cli>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<resque>, [">= 0"])
      s.add_runtime_dependency(%q<resque-meta>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<vegas>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<autotest-standalone>, [">= 0"])
    else
      s.add_dependency(%q<sequel>, [">= 3.33.0"])
      s.add_dependency(%q<pg>, [">= 0"])
      s.add_dependency(%q<mixlib-config>, [">= 0"])
      s.add_dependency(%q<mixlib-log>, [">= 0"])
      s.add_dependency(%q<mixlib-shellout>, [">= 0"])
      s.add_dependency(%q<mixlib-cli>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<resque>, [">= 0"])
      s.add_dependency(%q<resque-meta>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<vegas>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<autotest-standalone>, [">= 0"])
    end
  else
    s.add_dependency(%q<sequel>, [">= 3.33.0"])
    s.add_dependency(%q<pg>, [">= 0"])
    s.add_dependency(%q<mixlib-config>, [">= 0"])
    s.add_dependency(%q<mixlib-log>, [">= 0"])
    s.add_dependency(%q<mixlib-shellout>, [">= 0"])
    s.add_dependency(%q<mixlib-cli>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<resque>, [">= 0"])
    s.add_dependency(%q<resque-meta>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<vegas>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<autotest-standalone>, [">= 0"])
  end
end

