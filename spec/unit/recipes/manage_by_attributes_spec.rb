require_relative '../../spec_helper'

describe 'certificate::manage_by_attributes' do
  cached(:subject) { chef_run }

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

  default_attributes['certificate'] = [
    'foo' => {
      data_bag_type: 'none',
      plaintext_cert: 'plain_cert',
      plaintext_key: 'plain_key',
      plaintext_chain: 'plain_chain',
    },
    'test' => {},
  ]

  it do
    is_expected.to create_certificate_manage('foo').with(
      data_bag_type: 'none',
      plaintext_cert: 'plain_cert',
      plaintext_key: 'plain_key',
      plaintext_chain: 'plain_chain'
    )
  end

  it { is_expected.to create_certificate_manage('test') }
end
