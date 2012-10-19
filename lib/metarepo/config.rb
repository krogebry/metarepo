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

require 'mixlib/config'

class Metarepo
  class Config
    extend Mixlib::Config

		uri "https://15.184.34.120"
    gpg_key "metarepo@example.com"
    pool_path '/mnt/data/metarepo/pool'
    repo_path '/mnt/data/metarepo/repo'
    db_connect 'mysql2://metarepo:329ff6a7edd44123b3fcb91faa759b47@mysql.rndc.aw1.hpcloud.net/metarepo_production'
    upstream_path '/mnt/data/metarepo/upstream'

  end
end

