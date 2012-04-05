#
# Cookbook:: certificate
# Resources:: manage
#
# Copyright 2012, Eric G. Wolfe
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

def initialize(*args)
  super
  @action = :create
end

actions :create

# :data_bag is the Data Bag to search.
# :search_id is the Data Bag object you wish to search.
attribute :data_bag, :kind_of => String, :default => "certificates"
attribute :search_id, :kind_of => String, :name_attribute => true 

# :cert_file is the filename for the managed certificate.
# :key_file is the filename for the managed key.
# :chain_file is the filename for the managed CA chain.
# :cert_path is the top-level directory for certs/keys (certs and private sub-folders are where the files will be placed)
case node['platform']
when "redhat","centos","scientific","amazon","fedora"
attribute :cert_path, :kind_of => String, :default => "/etc/pki/tls"
when "debian","ubuntu"
attribute :cert_path, :kind_of => String, :default => "/etc/ssl"
else
attribute :cert_path, :kind_of => String, :default => "/etc/ssl"
end
attribute :cert_file, :kind_of => String, :default => "#{node['fqdn']}.pem"
attribute :key_file, :kind_of => String, :default => "#{node['fqdn']}.key"
attribute :chain_file, :kind_of => String, :default => "#{node['hostname']}-bundle.crt"

# The owner and group of the managed certificate and key
attribute :owner, :kind_of => String, :default => "root"
attribute :group, :kind_of => String, :default => "root"

# Cookbook to search for blank.erb template 
attribute :cookbook, :kind_of => String, :default => "certificate"
