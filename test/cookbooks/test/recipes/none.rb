# frozen_string_literal: true

# suite: none
# Plaintext party! No data bags required! 🎈✨
certificate_manage 'test' do
  data_bag_type 'none'
  plaintext_cert "-----BEGIN CERTIFICATE-----\nCERT\n-----END CERTIFICATE-----\n"
  plaintext_key "-----BEGIN PRIVATE KEY-----\nKEY\n-----END PRIVATE KEY-----\n"
  plaintext_chain "-----BEGIN CERTIFICATE-----\nCHAIN\n-----END CERTIFICATE-----\n"
  cert_file 'test.pem'
  key_file 'test.key'
  chain_file 'test-chain.pem'
end
