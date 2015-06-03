require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class CertificateManage < Chef::Resource::LWRPBase
      self.resource_name = :certificate_manage

      def initialize(*args)
        super
        @action = :create
        @sensitive = true
      end

      actions :create, :remove
      default_action :create

      # :data_bag is the Data Bag to search.
      # :data_bag_secret is the path to the file with the data bag secret
      # :data_bag_type is the type of data bag (i.e. unenc, enc, vault)
      # :search_id is the Data Bag object you wish to search.
      attribute :data_bag, :kind_of => String, :default => 'certificates'
      attribute :data_bag_secret, :kind_of => String, :default => Chef::Config['encrypted_data_bag_secret']
      attribute :data_bag_type, :kind_of => String, :equal_to => %w(unencrypted encrypted vault custom), :default => 'encrypted'
      attribute :search_id, :kind_of => String, :name_attribute => true
      attribute :ignore_missing, :kind_of => [TrueClass, FalseClass], :default => false

      # :nginx_cert is a PEM which combine host cert and CA trust chain for nginx.
      # :combined_file is a PEM which combine certs and keys in one file, for things such as haproxy.
      # :cert_file is the filename for the managed certificate.
      # :key_file is the filename for the managed key.
      # :chain_file is the filename for the managed CA chain.
      # :cert_path is the top-level directory for certs/keys (certs and private sub-folders are where the files will be placed) determined by funtction cert_path
      # :create_subfolders will automatically create certs and private sub-folders

      attribute :cert_path, :kind_of => String, :default => nil
      attribute :nginx_cert, :kind_of => [TrueClass, FalseClass], :default => false
      attribute :combined_file, :kind_of => [TrueClass, FalseClass], :default => false
      attribute :cert_file, :kind_of => String, :default => nil
      attribute :key_file, :kind_of => String, :default => nil
      attribute :chain_file, :kind_of => String, :default => nil
      attribute :create_subfolders, :kind_of => [TrueClass, FalseClass], :default => true

      # Custom attributes only
      # :certificate is the certifcate file.
      # :key is the key file.
      # :chain is chain file.
      # :cert_file_source is the content of the certifcate file.
      # :key_file_source is the content of the key file.
      # :chain_file_source is the content of the chain file.
      # attribute :certificate, :kind_of => String, :default => nil
      # attribute :key, :kind_of => String, :default => nil
      # attribute :chain, :kind_of => String, :default => nil
      attribute :cert_file_source, :kind_of => String, :default => nil
      attribute :key_file_source, :kind_of => String, :default => nil
      attribute :chain_file_source, :kind_of => String, :default => nil

      # The owner and group of the managed certificate and key
      attribute :owner, :kind_of => String, :default => 'root'
      attribute :group, :kind_of => String, :default => 'root'

      # Cookbook to search for blank.erb template
      attribute :cookbook, :kind_of => String, :default => 'certificate'
    end
  end
end
