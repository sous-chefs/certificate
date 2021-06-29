require_relative '../../spec_helper'

describe 'certificate::default' do
  cached(:subject) { chef_run }

  platform 'centos'

  it do
    is_expected.to create_certificate_manage('Fauxhai').with(
      ignore_missing: true
    )
  end
end
