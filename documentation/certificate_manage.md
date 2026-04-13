# certificate_manage

The `certificate_manage` resource automates the common task of managing X.509 certificates, private keys, and CA root bundles from various Chef Data Bag formats or direct plaintext input.

## Actions

- `:create`: (default) Creates the certificate, key, and chain files.
- `:delete`: Deletes the certificate, key, and chain files.

## Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `data_bag` | String | `'certificates'` | Name of the data bag to search. |
| `data_bag_secret` | String | `nil` | Path to the file with the data bag secret. |
| `data_bag_type` | String | `'encrypted'` | Type of data bag: `'unencrypted'`, `'encrypted'`, or `'none'`. |
| `search_id` | String | `name_property` | The ID of the data bag item to fetch. |
| `ignore_missing` | Boolean | `false` | If true, don't fail if the data bag item is missing. |
| `plaintext_cert` | String | `nil` | Plaintext certificate content (used when `data_bag_type` is `'none'`). |
| `plaintext_key` | String | `nil` | Plaintext private key content (used when `data_bag_type` is `'none'`). |
| `plaintext_chain` | String | `nil` | Plaintext CA chain content (used when `data_bag_type` is `'none'`). |
| `cert_path` | String | `lazy { default_cert_path }` | Top-level directory for certs/keys. |
| `cert_file` | String | `lazy { "#{node['fqdn']}.pem" }` | Filename for the managed certificate. |
| `key_file` | String | `lazy { "#{node['fqdn']}.key" }` | Filename for the managed private key. |
| `chain_file` | String | `lazy { "#{node['hostname']}-bundle.crt" }` | Filename for the managed CA chain. |
| `create_subfolders` | Boolean | `true` | Automatically create `certs/` and `private/` sub-folders. |
| `nginx_cert` | Boolean | `false` | Create a combined host cert and CA trust chain for Nginx. |
| `combined_file` | Boolean | `false` | Combine cert, chain, and key into one file (e.g., for HAProxy). |
| `owner` | String, Integer | `'root'` | Owner of the managed files. |
| `group` | String, Integer | `'root'` | Group of the managed files. |
| `sensitive` | Boolean | `true` | Hide output in Chef Infra Client logs. |

## Examples

### Create a certificate from an encrypted data bag

```ruby
certificate_manage 'my_site' do
  data_bag 'my_certs'
  data_bag_type 'encrypted'
end
```

### Create a certificate from plaintext

```ruby
certificate_manage 'direct_input' do
  data_bag_type 'none'
  plaintext_cert '-----BEGIN CERTIFICATE-----\n...'
  plaintext_key '-----BEGIN PRIVATE KEY-----\n...'
end
```

### Create a combined cert for Nginx

```ruby
certificate_manage 'nginx_cert' do
  nginx_cert true
end
```

### Create a combined cert for HAProxy

```ruby
certificate_manage 'haproxy_cert' do
  combined_file true
end
```

### Cleanup

```ruby
certificate_manage 'old_cert' do
  action :delete
end
```
