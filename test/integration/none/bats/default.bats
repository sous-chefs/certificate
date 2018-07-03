#!/usr/bin/env bats

@test 'test.pem contains valid decoded certificate(s)' {
  (openssl x509 -in /etc/pki/tls/certs/test.pem || openssl x509 -in /etc/ssl/certs/test.pem)
}

@test 'private directory is 0750' {
  if -d /etc/pki/tls/private; then
    stat /etc/pki/tls/private | egrep 'Access.*0750'
  elif -d /etc/ssl/private; then
    stat /etc/ssl/private | egrep 'Access.*0750'
  fi
}

@test 'private key is 0640' {
  if -f /etc/pki/tls/private/test.pem; then
    stat /etc/pki/tls/private/test.pem | egrep 'Access.*0640'
  elif -d /etc/ssl/private/test.pem; then
    stat /etc/ssl/private/test.epm | egrep 'Access.*0640'
  fi
}
