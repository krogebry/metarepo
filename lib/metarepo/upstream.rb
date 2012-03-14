#
# Author: adam@opscode.com
#
# Copyright 2012, Opscode, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'metarepo/package'

class Metarepo
  class Upstream < Sequel::Model
    plugin :validation_helpers

    many_to_many :packages

    def validate
      super
      validates_unique :name
      validates_presence [ :path, :type ]
      errors.add(:type, "must be yum, apt or dir") unless [ "yum", "apt", "dir" ].include?(type)
    end

    def list_packages
      case type
      when "yum"
        Dir[File.join(path, "*.rpm")]
      when "apt"
      when "dir"
        [
          Dir[File.join(path, "*.rpm")],
          Dir[File.join(path, "*.deb")]
        ].flatten
      end
    end

    def sync_packages(file_list=nil)
      file_list ||= list_packages
      save
      seen_list = []
      file_list.each do |pkg|
        package = Metarepo::Package.from_file(pkg)
        seen_list << package.shasum
        db.transaction do
          package.save
          add_package(package) unless packages.detect { |o| o.shasum == package.shasum } 
        end
      end

      # Remove no longer relevant associations
      packages(true).detect do |pkg|
        remove_package(pkg) unless seen_list.include?(pkg.shasum)
      end
    end
  end
end