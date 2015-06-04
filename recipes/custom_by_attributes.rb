#
# Cookbook Name:: certificate
# Recipe::custom_by_attributes
#
# Copyright 2012, Eric G. Wolfe
#
# Recipe Information
# Author: Yukihiko Sawanoborii (HiganWorks LLC)
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

certificate_manage 'Install certificate' do
  cert_file node['certificate']['cert_file']
  key_file node['certificate']['key_file']
  chain_file node['certificate']['chain_file']
  cert_file_source node['certificate']['cert_file_source']
  key_file_source node['certificate']['key_file_source']
  chain_file_source node['certificate']['chain_file_source']
  data_bag_type 'custom'
end
