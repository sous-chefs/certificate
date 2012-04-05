#
# Cookbook:: certificate
# Provider:: manage
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

action :create do
  directory "#{new_resource.cert_path}/certs" do
    owner new_resource.owner
    group new_resource.group
    mode "0755"
    recursive true
    not_if "test -d #{new_resource.cert_path}/certs"
  end

  directory "#{new_resource.cert_path}/private" do
    owner new_resource.owner
    group new_resource.group
    mode "0750"
    recursive true
    not_if "test -d #{new_resource.cert_path}/private"
  end

  ssl_item = Chef::EncryptedDataBagItem.load(new_resource.data_bag, new_resource.search_id)

  template "#{new_resource.cert_path}/certs/#{new_resource.cert_file}" do
    source "blank.erb"
    cookbook new_resource.cookbook 
    mode "0644"
    owner new_resource.owner
    group new_resource.group
    variables(:file_content => ssl_item['cert'])
  end

  template "#{new_resource.cert_path}/private/#{new_resource.key_file}" do
    source "blank.erb"
    cookbook new_resource.cookbook
    mode "0640"
    owner new_resource.owner
    group new_resource.group
    variables(:file_content => ssl_item['key'])
  end

  if ssl_item['chain']
    template "#{new_resource.cert_path}/certs/#{new_resource.chain_file}" do
      source "blank.erb"
      cookbook new_resource.cookbook
      mode "0644"
      owner new_resource.owner
      group new_resource.group
      variables(:file_content => ssl_item['chain'])
    end
  end
end
