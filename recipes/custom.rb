certificate_manage 'custom_test' do
  cert_file 'custom_test.pem'
  key_file 'custom_test.key'
  chain_file 'custom_test_bundle.crt'
  cert_file_source '-----BEGIN CERTIFICATE-----\ncertificate\n-----END CERTIFICATE-----'
  key_file_source '-----BEGIN KEY-----\nkey\n-----END KEY-----'
  chain_file_source '-----BEGIN CERTIFICATE-----\nca_certificate\n-----END CERTIFICATE-----'
  data_bag_type 'custom'
end

# certificate_manage 'custom_test' do
#   cert_file 'custom_test.pem'
#   key_file 'custom_test.key'
#   chain_file 'custom_test_bundle.crt'
#   action :remove
# end
