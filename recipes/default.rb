#
# Cookbook Name:: certificate
# Recipe:: default
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

ssl_item = Chef::EncryptedDataBagItem.load(node['certificate']['data_bag'], node['certificate']['cert_id'])

template node['certificate']['cert_file'] do
  source "blank.erb"
  mode "0644"
  owner node['certificate']['owner']
  group node['certificate']['group']
  variables(:file_content => ssl_item['cert'])
end

template node['certificate']['key_file'] do
  source "blank.erb"
  mode "0640"
  owner node['certificate']['owner']
  group node['certificate']['group']
  variables(:file_content => ssl_item['key'])
end

if ssl_item['chain']
  template node['certificate']['chain_file'] do
    source "blank.erb"
    mode "0644"
    owner node['certificate']['owner']
    group node['certificate']['group']
    variables(:file_content => ssl_item['chain'])
  end
end
