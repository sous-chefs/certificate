module CertificateManage
  module Helpers
    # Determine certificate path
    def cert_path
      case node['platform_family']
      when 'rhel'
        return '/etc/pki/tls'
      when 'debian'
        return '/etc/ssl'
      when 'smartos'
        return '/opt/local/etc/openssl'
      else
        return '/etc/ssl'
      end
    end

    # Global functions
    def cert_directory_resource(dir, options = {})
      r = directory ::File.join(cert_path, dir) do
        owner new_resource.owner
        group new_resource.group
        mode(options[:private] ? 00750 : 00755)
        recursive true
      end
      new_resource.updated_by_last_action(true) if r.updated_by_last_action?
    end

    def cert_file_resource(path, content, options = {})
      r = template path do
        source 'blank.erb'
        cookbook new_resource.cookbook
        owner new_resource.owner
        group new_resource.group
        mode(options[:private] ? 00640 : 00644)
        variables :file_content => content
        only_if { content }
        sensitive new_resource.sensitive if respond_to?(:sensitive)
      end
      new_resource.updated_by_last_action(true) if r.updated_by_last_action?
    end

    def delete_cert_file(path)
      file path do
        action :delete
        only_if { ::File.exist?(path) }
      end
      new_resource.updated_by_last_action(true) if new_resource.updated_by_last_action?
    end

    # Accesors for determining where files should be placed

    def chain_file
      "#{node['hostname']}-bundle.crt"
    end

    def cert(cert_path, cert_file, create_subfolders)
      bits = [cert_path, cert_file]
      bits.insert(1, 'certs') if create_subfolders
      ::File.join(bits)
    end

    def cert_key(cert_path, key_file, create_subfolders)
      bits = [cert_path, key_file]
      bits.insert(1, 'private') if create_subfolders
      ::File.join(bits)
    end

    def cert_chain(cert_path, chain_file, create_subfolders)
      bits = [cert_path, chain_file]
      bits.insert(1, 'certs') if create_subfolders
      ::File.join(bits)
    end
  end
end
