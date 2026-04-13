# frozen_string_literal: true

unified_mode true
provides :certificate_manage
default_action :create

# --- Properties ---

# :data_bag is the Data Bag to search.
# :data_bag_secret is the path to the file with the data bag secret
# :data_bag_type is the type of data bag (i.e. unenc, enc, chef-vault)
# :search_id is the Data Bag object you wish to search.
property :data_bag, String, default: 'certificates'
property :data_bag_secret, String
property :data_bag_type, String, equal_to: %w(unencrypted encrypted chef-vault none), default: 'encrypted'
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
# :cert_path is the top-level directory for certs/keys
# :create_subfolders will automatically create certs and private sub-folders
property :cert_path, String, default: lazy { default_cert_path }
property :nginx_cert, [true, false], default: false
property :combined_file, [true, false], default: false
property :cert_file, String, default: lazy { "#{node['fqdn']}.pem" }
property :key_file, String, default: lazy { "#{node['fqdn']}.key" }
property :chain_file, String, default: lazy { "#{node['hostname']}-bundle.crt" }
property :create_subfolders, [true, false], default: true

# The owner and group of the managed certificate and key
property :owner, [String, Integer], default: 'root'
property :group, [String, Integer], default: 'root'

# sensitive by default
property :sensitive, [true, false], default: true

# --- Action Class ---

action_class do
  include Certificate::Cookbook::Helpers

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

# --- Actions ---

action :create do
  cert_data = case new_resource.data_bag_type
              when 'encrypted', 'unencrypted'
                begin
                  data_bag_item(
                    new_resource.data_bag,
                    new_resource.search_id,
                    new_resource.data_bag_secret
                  )
                rescue => e
                  raise e unless new_resource.ignore_missing
                  nil
                end

              when 'chef-vault'
                begin
                  chef_vault_item(new_resource.data_bag, new_resource.search_id)
                rescue => e
                  raise e unless new_resource.ignore_missing
                  nil
                end

              when 'none' # just take arbitrary plain text from resource properties
                {
                  'cert' => new_resource.plaintext_cert,
                  'key' => new_resource.plaintext_key,
                  'chain' => new_resource.plaintext_chain,
                }

              else
                raise "Unsupported data bag type #{new_resource.data_bag_type}"
              end

  if cert_data.nil?
    Chef::Log.warn("No certificate data found for #{new_resource.search_id}!")
    next
  end

  if new_resource.create_subfolders
    directory ::File.join(new_resource.cert_path, 'certs') do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      recursive true
    end

    directory ::File.join(new_resource.cert_path, 'private') do
      owner new_resource.owner
      group new_resource.group
      mode '0750'
      recursive true
    end
  end

  # Special handling for combined files (e.g. HAProxy)
  if new_resource.combined_file
    file certificate_path do
      content "#{cert_data['cert']}\n#{cert_data['chain']}\n#{cert_data['key']}"
      owner new_resource.owner
      group new_resource.group
      mode '0640'
      sensitive new_resource.sensitive
    end

    next
  end

  # Combined cert file for nginx
  if new_resource.nginx_cert
    file certificate_path do
      content "#{cert_data['cert']}\n#{cert_data['chain']}"
      owner new_resource.owner
      group new_resource.group
      mode '0640'
      sensitive new_resource.sensitive
    end
  else
    # Separate chain and cert files
    file certificate_path do
      content cert_data['cert']
      owner new_resource.owner
      group new_resource.group
      mode '0644'
      sensitive new_resource.sensitive
    end

    file chain_path do
      content cert_data['chain']
      owner new_resource.owner
      group new_resource.group
      mode '0644'
      sensitive new_resource.sensitive
    end
  end

  # Private key
  file key_path do
    content cert_data['key']
    owner new_resource.owner
    group new_resource.group
    mode '0640'
    sensitive new_resource.sensitive
  end
end

action :delete do
  file certificate_path do
    action :delete
  end

  file key_path do
    action :delete
    not_if { new_resource.combined_file }
  end

  file chain_path do
    action :delete
    not_if { new_resource.combined_file || new_resource.nginx_cert }
  end
end
