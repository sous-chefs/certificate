# Certificate cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/rsync.svg)](https://supermarket.chef.io/cookbooks/certificate)
[![CI State](https://github.com/sous-chefs/rsync/workflows/ci/badge.svg)](https://github.com/sous-chefs/certificate/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

This recipe automates the common task of managing x509 certificates and keys from encrypted Data Bags. This cookbook
provides a flexible and reusable resource to set up certificates from various sources.

### Warning about Vault mode

Pulling data from Chef Vault is not supported when using `chef-solo`, and will result in a failure condition.

### Testing with encrypted data_bags

The stub files in `test/integration` are for testing only and should not be used in production. These files include a
self-signed "snake oil" certificate/key and an `encrypted_data_bag_secret` file which are not secure to use beyond
testing.

## Requirements

### Prepping certificate data

The certificate strings in the data bag need all newlines replaced with literal `\n`s. This conversion can be done with
a Ruby one-liner:

```console
ruby -e 'p ARGF.read' <filename>
```

This will turn the input file from the normal certificate format:

```text
-----BEGIN CERTIFICATE-----
MIIEEDCCA3mgAwIBAgIJAO4rOcmpIFmPMA0GCSqGSIb3DQEBBQUAMIG3MQswCQYD
-----END CERTIFICATE-----
```

Into this:

```text
-----BEGIN CERTIFICATE-----\nMIIEEDCCA3mgAwIBAgIJAO4rOcmpIFmPMA0GCSqGSIb3DQEBBQUAMIG3MQswCQYD\n-----END CERTIFICATE-----
```

Add the converted certificate / chain / key to the desired databag, attributes, or Chef Vault store:

```json
{
  "id": "example",
  "cert": "-----BEGIN CERTIFICATE-----\nCertificate Here...",
  "key": "-----BEGIN PRIVATE KEY\nPrivate Key Here...",
  "chain": "-----BEGIN CERTIFICATE-----\nCA Root Chain Here..."
}
```

The `chain` entry may be optional if the CA's root chain is already trusted by the server.

## Recipes

This cookbook comes with three simple example recipes for using the *certificate_manage* LWRP.

### `certificate::default`

Creates certificates from the data bag item `certificates/$HOSTNAME`.

### `certificate::wildcard`

Same as the default recipe, except for the data bag item name is `wildcard` instead of the node hostname.

The resulting files will be named wildcard.pem (cert), wildcard.key (key), and wildcard-bundle.crt (CA Root chain)

### `certificate::manage_by_attributes`

Defines `certificate_manage` resources dynamically from node attributes.

<!-- use raw html table for multi line code blocks -->
<!-- markdownlint-disable no-inline-html -->
<table>
<tr>
<td> Attributes </td> <td> Equivalent resources </td>
</tr>
<tr>
<td>

```ruby
node['certificate'] = [
  {
    'foo' => {
      data_bag_type: 'none',
      plaintext_cert: 'plain_cert',
      plaintext_key: 'plain_key',
      plaintext_chain: 'plain_chain',
    }
  },
  {'test' => {}},
]
```

</td>
<td>

```ruby
certificate_manage 'foo' do
  data_bag_type 'none'
  plaintext_cert 'plain_cert'
  plaintext_key 'plain_key'
  plaintext_chain 'plain_chain'
end

certificate_manage 'test'
```

</td>
</tr>
</table>
<!-- markdownlint-enable no-inline-html -->

## Resources

### `certificate_manage`

Sets up certificates from data bags or Chef Vault stores.

| Property            | Default                                     | Description                                                                                                                           |
|---------------------|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| `data_bag`          | `certificate`                               | Name of the data bag to look in                                                                                                       |
| `data_bag_secret`   | `Chef::Config['encrypted_data_bag_secret']` | Path to the file with the data bag secret                                                                                             |
| `data_bag_type`     | `encrypted`                                 | Where to get certificate data from: `encrypted` or `unencrypted` data bag, `vault` for Chef Vault, or `none` for plaintext properties |
| `search_id`         | Resource name                               | Name of the data bag item to use                                                                                                      |
| `plaintext_cert`    |                                             | Manual cert input for `none` data bag type                                                                                            |
| `plaintext_key`     |                                             | Manual key input for `none` data bag type                                                                                             |
| `plaintext_chain`   |                                             | Manual chain input for `none` data bag type                                                                                           |
| `cert_path`         | `/etc/pki/tls` on RHEL, else `/etc/ssl`     | Directory to place certificates in                                                                                                    |
| `create_subfolders` | `true`                                      | Whether to use `private/` and `certs/` subdirectories under `cert_path`                                                               |
| `cert_file`         | `$FQDN.pem`                                 | Basename of the certificate                                                                                                           |
| `key_file`          | `$FQDN.key`                                 | Basename of the private key                                                                                                           |
| `chain_file`        | `$HOSTNAME-bundle.pem`                      | Basename of the chain certificate                                                                                                     |
| `nginx_cert`        | `false`                                     | Whether to create a combined cert/chain certificate for use with Nginx instead of separate certs                                      |
| `combined_file`     | `false`                                     | Whether to combine the cert, chain, and key into a single file                                                                        |
| `owner`             | `root`                                      | File owner of the certificates                                                                                                        |
| `group`             | `root`                                      | File group of the certificates                                                                                                        |
| `cookbook`          | `certificate`                               | Cookbook containing the certificate file template.                                                                                    |

### Example

The following example will place certificates defined in the `certificates/mail` data bag item under `/etc/postfix/ssl`
owned by postfix.

```ruby
certificate_manage "mail" do
  cert_path "/etc/postfix/ssl"
  owner "postfix"
  group "postfix"
end
```

### .certificate, .key, .chain helper method usage

Some helper methods are exposed for retrieving key/certificate paths in other recipes:

- `.certificate` - The final path of the certificate file. i.e. `#{cert_path}/certs/#{cert_file}`
- `.key` - The final path of the key file. i.e. `#{cert_path}/private/#{key_file}`
- `.chain` - The final path of the chain file. i.e. `#{cert_path}/certs/#{chain_file}`

```rb
# where node.fqdn = 'example.com'
tld = certificate_manage 'top_level_domain'
tld_cert_location = tld.certificate # => /etc/ssl/certs/example.com.pem

# where node.fqdn = 'sub.example.com'
sbd = certificate_manage 'sub_domain' do
  cert_path '/bobs/emporium'
  create_subfolders false
end
sbd_cert_location = sbd.key # => /bobs/emporium/sub.example.com.key
```

### Setting FQDN during the converge

If the FQDN of the node is updated during converge, be sure to use [lazy attribute
evaluation](https://docs.chef.io/resource_common.html#lazy-attribute-evaluation) to ensure `node['fqdn']` refers to the
updated value.

```ruby
certificate_manage "wildcard" do
  cert_file lazy { "#{node['fqdn']}.pem" }
  key_file lazy { "#{node['fqdn']}.key" }
  chain_file lazy { "#{node['fqdn']}-bundle.crt" }
end
```

### Using the `none` data bag type

The `none` option does not use a data bag, requiring the certificate, key, and/or chain to be passed directly to the
resource. This allows you to use the `certificate_manage` resource for all of your certificate needs, even if the
certificate data is stored in an unsupported location.

```ruby
certificate_manage "fqdn-none-plaintext" do
  cert_file lazy { "#{node['fqdn']}.pem" }
  key_file lazy { "#{node['fqdn']}.key" }
  chain_file lazy { "#{node['fqdn']}-bundle.crt" }
  data_bag_type 'none'
  plaintext_cert "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----\n\n"
  plaintext_key "-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----\n\n",
  plaintext_chain "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----\n\n",
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
