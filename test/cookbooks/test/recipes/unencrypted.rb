# frozen_string_literal: true

# suite: unencrypted
# Let's test unencrypted data bags! 🥳
certificate_manage 'test' do
  data_bag_type 'unencrypted'
  cert_file 'test.pem'
  key_file 'test.key'
  chain_file 'test-chain.pem'
end
