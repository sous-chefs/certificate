# frozen_string_literal: true

# suite: default
# Default party! 🎉
certificate_manage 'test' do
  cert_file 'test.pem'
  key_file 'test.key'
  chain_file 'test-chain.pem'
  ignore_missing true
end
