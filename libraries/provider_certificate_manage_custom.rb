require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class CertificateManageCustom < Chef::Provider::LWRPBase
      provides :certificate_manage
      include CertificateManage::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :create do
        if new_resource.create_subfolders
          cert_directory_resource 'certs'
          cert_directory_resource 'private', :private => true
        end

        certificate = cert(cert_path, new_resource.cert_file, new_resource.create_subfolders)
        key = cert_key(cert_path, new_resource.key_file, new_resource.create_subfolders)
        chain = cert_chain(cert_path, chain_file, new_resource.create_subfolders)

        if new_resource.nginx_cert
          cert_file_resource certificate, "#{new_resource.cert_file_source}\n#{new_resource.chain_file_source}"
        else
          cert_file_resource certificate, new_resource.cert_file_source
          cert_file_resource chain, new_resource.chain_file_source
        end
        cert_file_resource key, new_resource.key_file_source, :private => true
      end

      class << self
         def supports?(resource, _action)
           resource.data_bag_type == 'custom'
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
