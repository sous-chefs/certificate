module Certificate
  module Cookbook
    module Helpers
      def default_cert_path
        if platform_family?('rhel', 'fedora')
          '/etc/pki/tls'
        else
          '/etc/ssl'
        end
      end

      def chef_vault_item(bag, id)
        if ChefVault::Item.vault?(bag, id)
          ChefVault::Item.load(bag, id)
        else
          data_bag_item(bag, id)
        end
      end
    end
  end
end

Chef::DSL::Recipe.include ::Certificate::Cookbook::Helpers
Chef::Resource.include ::Certificate::Cookbook::Helpers
