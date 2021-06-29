#
# Cookbook:: certificate
# Resources:: manage
#
# Copyright:: 2012, Eric G. Wolfe
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

provides :certificate_manage
resource_name :certificate_manage
unified_mode true

default_action :create

# :data_bag is the Data Bag to search.
# :data_bag_secret is the path to the file with the data bag secret
# :data_bag_type is the type of data bag (i.e. unenc, enc, vault)
# :search_id is the Data Bag object you wish to search.
property :data_bag, String, default: 'certificates'
property :data_bag_secret, String, default: Chef::Config['encrypted_data_bag_secret']
property :data_bag_type, String, equal_to: %w(unencrypted encrypted vault none), default: 'encrypted'
property :search_id, String, name_property: true
property :ignore_missing, [true, false], default: false

# When :data_bag_type is none, accept arbitrary plaintext for key, cert, chain
property :plaintext_cert, String
property :plaintext_key, String
property :plaintext_chain, String

# :nginx_cert is a PEM which combine host cert and CA trust chain for nginx.
# :combined_file is a PEM which combine certs and keys in one file, for things such as haproxy.
# :cert_file is the filename for the managed certificate.
# :key_file is the filename for the managed key.
# :chain_file is the filename for the managed CA chain.
# :default_cert_path is the top-level directory for certs/keys (certs and private sub-folders are where the files will be placed)
# :new_resource.create_subfolders will automatically create certs and private sub-folders
property :cert_path, String, default: lazy { default_cert_path }
property :nginx_cert, [true, false], default: false
property :combined_file, [true, false], default: false
property :cert_file, String, default: "#{node['fqdn']}.pem"
property :key_file, String, default: "#{node['fqdn']}.key"
property :chain_file, String, default: "#{node['hostname']}-bundle.crt"
property :create_subfolders, [true, false], default: true

# The owner and group of the managed certificate and key
property :owner, String, default: 'root'
property :group, String, default: 'root'

# Cookbook to search for blank.erb template
property :cookbook, String, default: 'certificate'

# sensitive by default
property :sensitive, [true, false], default: true

action_class do
  include Certificate::Cookbook::Helpers

  # Accesors for determining where files should be placed
  def certificate_path
    bits = [new_resource.cert_path, new_resource.cert_file]
    bits.insert(1, 'certs') if new_resource.create_subfolders
    ::File.join(bits)
  end

  def key_path
    bits = [new_resource.cert_path, new_resource.key_file]
    bits.insert(1, 'private') if new_resource.create_subfolders
    ::File.join(bits)
  end

  def chain_path
    bits = [new_resource.cert_path, new_resource.chain_file]
    bits.insert(1, 'certs') if new_resource.create_subfolders
    ::File.join(bits)
  end
end

action :create do
  cert_data = case new_resource.data_bag_type
              when 'encrypted', 'unencrypted'
                begin
                  data_bag_item(
                    new_resource.data_bag,
                    new_resource.search_id,
                    (new_resource.data_bag_secret if new_resource.data_bag_type == 'encrypted')
                  )
                rescue => e
                  raise e unless new_resource.ignore_missing
                  nil
                end

              when 'vault'
                # vault doesn't work in chef-solo
                raise('Vault type encryption not supported with chef-solo') if Chef::Config['solo']

                chef_vault_item(new_resource.data_bag, new_resource.search_id)

              when 'none' # just take arbitrary plain text from resource properties
                {
                  'cert' => new_resource.plaintext_cert,
                  'key' => new_resource.plaintext_key,
                  'chain' => new_resource.plaintext_chain,
                  }

              else
                raise "Unsupported data bag type #{new_resource.data_bag_type}"
              end

  next if cert_data.nil?

  if new_resource.create_subfolders
    directory ::File.join(new_resource.default_cert_path, 'certs') do
      owner new_resource.owner
      group new_resource.group
      mode '755'
      recursive true
    end

    directory ::File.join(new_resource.default_cert_path, 'private') do
      owner new_resource.owner
      group new_resource.group
      mode '750'
      recursive true
    end
  end

  if new_resource.combined_file
    template certificate_path do
      source 'blank.erb'
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '640'
      variables(
        file_content: "#{cert_data['cert']}\n#{cert_data['chain']}\n#{cert_data['key']}"
      )
      sensitive new_resource.sensitive
    end

    next
  end

  if new_resource.nginx_cert
    # combined cert file for nginx
    template certificate_path do
      source 'blank.erb'
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '640'
      variables(
        file_content: "#{cert_data['cert']}\n#{cert_data['chain']}"
      )
      sensitive new_resource.sensitive
    end
  else
    # separate chain and cert files
    template certificate_path do
      source 'blank.erb'
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '644'
      variables(
        file_content: cert_data['cert']
      )
      sensitive new_resource.sensitive
    end

    template chain_path do
      source 'blank.erb'
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '644'
      variables(
        file_content: cert_data['chain']
      )
      sensitive new_resource.sensitive
    end
  end

  template key_path do
    source 'blank.erb'
    cookbook new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode '640'
    variables(
      file_content: cert_data['key']
    )
    sensitive new_resource.sensitive
  end
end
