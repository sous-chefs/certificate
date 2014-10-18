require 'spec_helper'

describe 'certificate::default' do
  secret_file_path = 'test/integration/default/encrypted_data_bag_secret'
  before do
    @secret = Chef::EncryptedDataBagItem.load_secret(secret_file_path)
    @data_bag_item_content = JSON.parse(IO.read(File.join(File.dirname(__FILE__), '/../test/integration/default/data_bags/certificates/test.json')))
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['certificate_manage']) do |node|
      node.automatic_attrs['hostname'] = 'example.com'
      Chef::Config['encrypted_data_bag_secret'] = secret_file_path
    end.converge(described_recipe)
  end
end
