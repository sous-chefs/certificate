require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class CertificateManageVault < Chef::Provider::LWRPBase
      provides :certificate_manage
      include CertificateManage::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        # vault doesn't work in chef-solo
        Chef::Application.fatal!('Vault type encryption not supported with chef-solo') if Chef::Config['solo']
        ssl_item =
          begin
            chef_gem 'chef-vault'
            require 'chef-vault'
            ChefVault::Item.load(new_resource.data_bag, new_resource.search_id)
          rescue ChefVault::Exceptions::KeysNotFound, ChefVault::Exceptions::SecretDecryption
            begin
              Chef::DataBagItem.load(new_resource.data_bag, new_resource.search_id)
            rescue => e
              raise e unless new_resource.ignore_missing
              nil
            end
          end

        next if ssl_item.nil?

        certificate = cert(cert_path, new_resource.cert_file, new_resource.create_subfolders)
        key = cert_key(cert_path, new_resource.key_file, new_resource.create_subfolders)
        chain = cert_chain(cert_path, chain_file, new_resource.create_subfolders)

        if new_resource.combined_file
          cert_file_resource ::File.join(certificate_path, new_resource.cert_file),
                             "#{ssl_item['cert']}\n#{ssl_item['chain']}\n#{ssl_item['key']}",
                             :private => true
          next
        end

        if new_resource.create_subfolders
          cert_directory_resource 'certs'
          cert_directory_resource 'private', :private => true
        end

        if new_resource.nginx_cert
          cert_file_resource certificate, "#{ssl_item['cert']}\n#{ssl_item['chain']}"
        else
          cert_file_resource certificate, ssl_item['cert']
          cert_file_resource chain, ssl_item['chain']
        end
        cert_file_resource key, ssl_item['key'], :private => true
      end

      class << self
        def supports?(resource, _action)
          resource.data_bag_type == 'vault'
        end
      end

      action :remove do
        certificate = cert(cert_path, new_resource.cert_file, new_resource.create_subfolders)
        key = cert_key(cert_path, new_resource.key_file, new_resource.create_subfolders)

        delete_cert_file certificate
        delete_cert_file key
      end
    end
  end
end
