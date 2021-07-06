require_relative '../../spec_helper'

describe 'certificate_manage' do
  step_into :certificate_manage

  platform 'centos'

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

    context 'on centos' do
      cached(:subject) { chef_run }
      platform 'centos'

      it { is_expected.to create_directory('/etc/pki/tls/certs') }
      it { is_expected.to create_directory('/etc/pki/tls/private') }

      it do
        is_expected.to create_template('/etc/pki/tls/certs/fauxhai.local.pem').with(
          variables: {
            file_content: 'the_cert',
          }
        )
      end

      it do
        is_expected.to create_template('/etc/pki/tls/private/fauxhai.local.key').with(
          variables: {
            file_content: 'the_key',
          }
        )
      end

      it do
        is_expected.to create_template('/etc/pki/tls/certs/Fauxhai-bundle.crt').with(
          variables: {
            file_content: 'the_chain',
          }
        )
      end
    end

    context 'on ubuntu' do
      cached(:subject) { chef_run }
      platform 'ubuntu'

      it { is_expected.to create_directory('/etc/ssl/certs') }
      it { is_expected.to create_directory('/etc/ssl/private') }

      it do
        is_expected.to create_template('/etc/ssl/certs/fauxhai.local.pem').with(
          variables: {
            file_content: 'the_cert',
          }
        )
      end

      it do
        is_expected.to create_template('/etc/ssl/private/fauxhai.local.key').with(
          variables: {
            file_content: 'the_key',
          }
        )
      end

      it do
        is_expected.to create_template('/etc/ssl/certs/Fauxhai-bundle.crt').with(
          variables: {
            file_content: 'the_chain',
          }
        )
      end
    end
  end

  context 'with plaintext' do
    cached(:subject) { chef_run }
    platform 'centos'

    recipe do
      certificate_manage 'plain' do
        data_bag_type 'none'
        plaintext_cert 'plain_cert'
        plaintext_key 'plain_key'
        plaintext_chain 'plain_chain'
      end
    end

    it do
      is_expected.to create_template('/etc/pki/tls/certs/fauxhai.local.pem').with(
        variables: {
          file_content: 'plain_cert',
        }
      )
    end

    it do
      is_expected.to create_template('/etc/pki/tls/private/fauxhai.local.key').with(
        variables: {
          file_content: 'plain_key',
        }
      )
    end

    it do
      is_expected.to create_template('/etc/pki/tls/certs/Fauxhai-bundle.crt').with(
        variables: {
          file_content: 'plain_chain',
        }
      )
    end
  end

  context 'when not creating subdirs' do
    cached(:subject) { chef_run }
    platform 'centos'

    recipe do
      certificate_manage 'test' do
        create_subfolders false
      end
    end

    it { is_expected.to_not create_directory('/etc/pki/tls/certs') }
    it { is_expected.to_not create_directory('/etc/pki/tls/private') }

    it { is_expected.to create_template('/etc/pki/tls/fauxhai.local.pem') }
    it { is_expected.to create_template('/etc/pki/tls/fauxhai.local.key') }
    it { is_expected.to create_template('/etc/pki/tls/Fauxhai-bundle.crt') }
  end

  context 'with combined file' do
    cached(:subject) { chef_run }
    platform 'centos'

    recipe do
      certificate_manage 'test' do
        combined_file true
      end
    end

    it do
      is_expected.to create_template('/etc/pki/tls/certs/fauxhai.local.pem').with(
        variables: {
          file_content: "the_cert\nthe_chain\nthe_key",
        }
      )
    end

    it { is_expected.to_not create_template('/etc/pki/tls/private/fauxhai.local.key') }
    it { is_expected.to_not create_template('/etc/pki/tls/certs/Fauxhai-bundle.crt') }
  end

  context 'with nginx cert' do
    cached(:subject) { chef_run }
    platform 'centos'

    recipe do
      certificate_manage 'test' do
        nginx_cert true
      end
    end

    it do
      is_expected.to create_template('/etc/pki/tls/certs/fauxhai.local.pem').with(
        variables: {
          file_content: "the_cert\nthe_chain",
        }
      )
    end

    it do
      is_expected.to create_template('/etc/pki/tls/private/fauxhai.local.key').with(
        variables: {
          file_content: 'the_key',
        }
      )
    end

    it { is_expected.to_not create_template('/etc/pki/tls/certs/Fauxhai-bundle.crt') }
  end
end
