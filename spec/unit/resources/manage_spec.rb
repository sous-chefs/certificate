require_relative '../../spec_helper'

describe 'certificate_manage' do
  step_into :certificate_manage

  platform 'almalinux'

  before do
    stub_data_bag_item('certificates', 'test').and_return(
      {
        chain: 'the_chain',
        cert: 'the_cert',
        key: 'the_key',
      }
    )
  end

  context 'with default options' do
    recipe do
      certificate_manage 'test'
    end

    context 'on almalinux' do
      cached(:subject) { chef_run }
      platform 'almalinux'

      it { is_expected.to create_directory('/etc/pki/tls/certs') }
      it { is_expected.to create_directory('/etc/pki/tls/private') }

      it do
        is_expected.to create_file('/etc/pki/tls/certs/fauxhai.local.pem').with(
          content: 'the_cert'
        )
      end

      it do
        is_expected.to create_file('/etc/pki/tls/private/fauxhai.local.key').with(
          content: 'the_key'
        )
      end

      it do
        is_expected.to create_file('/etc/pki/tls/certs/Fauxhai-bundle.crt').with(
          content: 'the_chain'
        )
      end
    end

    context 'on ubuntu' do
      cached(:subject) { chef_run }
      platform 'ubuntu'

      it { is_expected.to create_directory('/etc/ssl/certs') }
      it { is_expected.to create_directory('/etc/ssl/private') }

      it do
        is_expected.to create_file('/etc/ssl/certs/fauxhai.local.pem').with(
          content: 'the_cert'
        )
      end

      it do
        is_expected.to create_file('/etc/ssl/private/fauxhai.local.key').with(
          content: 'the_key'
        )
      end

      it do
        is_expected.to create_file('/etc/ssl/certs/Fauxhai-bundle.crt').with(
          content: 'the_chain'
        )
      end
    end
  end

  context 'with plaintext' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    recipe do
      certificate_manage 'plain' do
        data_bag_type 'none'
        plaintext_cert 'plain_cert'
        plaintext_key 'plain_key'
        plaintext_chain 'plain_chain'
      end
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/fauxhai.local.pem').with(
        content: 'plain_cert'
      )
    end

    it do
      is_expected.to create_file('/etc/pki/tls/private/fauxhai.local.key').with(
        content: 'plain_key'
      )
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/Fauxhai-bundle.crt').with(
        content: 'plain_chain'
      )
    end
  end

  context 'when not creating subdirs' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    recipe do
      certificate_manage 'test' do
        create_subfolders false
      end
    end

    it { is_expected.to_not create_directory('/etc/pki/tls/certs') }
    it { is_expected.to_not create_directory('/etc/pki/tls/private') }

    it { is_expected.to create_file('/etc/pki/tls/fauxhai.local.pem') }
    it { is_expected.to create_file('/etc/pki/tls/fauxhai.local.key') }
    it { is_expected.to create_file('/etc/pki/tls/Fauxhai-bundle.crt') }
  end

  context 'with combined file' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    recipe do
      certificate_manage 'test' do
        combined_file true
      end
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/fauxhai.local.pem').with(
        content: "the_cert\nthe_chain\nthe_key"
      )
    end

    it { is_expected.to_not create_file('/etc/pki/tls/private/fauxhai.local.key') }
    it { is_expected.to_not create_file('/etc/pki/tls/certs/Fauxhai-bundle.crt') }
  end

  context 'with nginx cert' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    recipe do
      certificate_manage 'test' do
        nginx_cert true
      end
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/fauxhai.local.pem').with(
        content: "the_cert\nthe_chain"
      )
    end

    it do
      is_expected.to create_file('/etc/pki/tls/private/fauxhai.local.key').with(
        content: 'the_key'
      )
    end

    it { is_expected.to_not create_file('/etc/pki/tls/certs/Fauxhai-bundle.crt') }
  end

  context 'with chef-vault data bag type' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    before do
      allow_any_instance_of(Chef::Provider).to receive(:chef_vault_item).with('vault-certs', 'test').and_return(
        {
          'chain' => 'vault_chain',
          'cert' => 'vault_cert',
          'key' => 'vault_key',
        }
      )
    end

    recipe do
      certificate_manage 'test' do
        data_bag_type 'chef-vault'
        data_bag 'vault-certs'
        cert_file 'test.pem'
        key_file 'test.key'
        chain_file 'test-chain.pem'
      end
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/test.pem').with(
        content: 'vault_cert'
      )
    end

    it do
      is_expected.to create_file('/etc/pki/tls/private/test.key').with(
        content: 'vault_key'
      )
    end

    it do
      is_expected.to create_file('/etc/pki/tls/certs/test-chain.pem').with(
        content: 'vault_chain'
      )
    end
  end

  context 'with action :delete' do
    cached(:subject) { chef_run }
    platform 'almalinux'

    recipe do
      certificate_manage 'test' do
        action :delete
      end
    end

    it { is_expected.to delete_file('/etc/pki/tls/certs/fauxhai.local.pem') }
    it { is_expected.to delete_file('/etc/pki/tls/private/fauxhai.local.key') }
    it { is_expected.to delete_file('/etc/pki/tls/certs/Fauxhai-bundle.crt') }
  end
end
