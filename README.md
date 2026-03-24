# Certificate Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/certificate.svg)](https://supermarket.chef.io/cookbooks/certificate)
[![CI State](https://github.com/sous-chefs/certificate/actions/workflows/ci.yml/badge.svg)](https://github.com/sous-chefs/certificate/actions/workflows/ci.yml)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

This cookbook automates the management of X.509 certificates, private keys, and CA root bundles. It provides a powerful and flexible `certificate_manage` resource to fetch data from Chef Data Bags (encrypted or unencrypted) or direct plaintext input.

## Requirements

- **Chef Infra Client**: >= 15.3 (Required for `unified_mode`)

## Resources

### [certificate_manage](documentation/certificate_manage.md)

The primary resource for managing certificate files on disk.

```ruby
certificate_manage 'my_site' do
  data_bag 'my_certs'
  data_bag_type 'encrypted'
  owner 'www-data'
  group 'www-data'
end
```

See the [resource documentation](documentation/certificate_manage.md) for full details and examples!

## Usage

This cookbook is designed to be used as a dependency in your own cookbooks. Add `depends 'certificate'` to your `metadata.rb` and use the `certificate_manage` resource.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
