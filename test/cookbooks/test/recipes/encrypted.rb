# suite: encrypted
# Shhh! It's an encrypted secret party! 🔐🎉
certificate_manage 'test' do
  data_bag_type 'encrypted'
  data_bag 'certs-encrypted'
  cert_file 'test.pem'
  key_file 'test.key'
  chain_file 'test-chain.pem'
end
