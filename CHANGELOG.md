# certificate Cookbook CHANGELOG

This file is used to list changes made in each version of the certificate cookbook.

## [2.1.5](https://github.com/sous-chefs/certificate/compare/certificate-v2.1.4...certificate-v2.1.5) (2025-10-15)


### Bug Fixes

* **ci:** Update workflows to use release pipeline ([#113](https://github.com/sous-chefs/certificate/issues/113)) ([f4488e7](https://github.com/sous-chefs/certificate/commit/f4488e7a6dee08a498da9ce459ca046040675794))


### Reverts

* 38 ([000802f](https://github.com/sous-chefs/certificate/commit/000802f02a5c52c32cd4cc1b5ee24bf57d21f3ab))

## 2.1.3 - *2024-11-18*

Standardise files with files in sous-chefs/repo-management

## 2.1.2 - *2024-07-15*

Standardise files with files in sous-chefs/repo-management

## 2.1.1 - *2024-05-23*

Standardise files with files in sous-chefs/repo-management

## 2.1.0 - *2024-05-03*

* Allow owner and group to be String or Integer

## 2.0.16 - *2023-04-19*

* Various CI and Documentation cleanup

## 2.0.15 - *2023-04-07*

* Standardise files with files in sous-chefs/repo-management

## 2.0.14 - *2023-04-01*

* Update gaurav-nelson/github-action-markdown-link-check action to v1.0.15

## 2.0.13 - *2023-04-01*

* Update actions/stale action to v8

## 2.0.12 - *2023-04-01*

* Standardise files with files in sous-chefs/repo-management

## 2.0.11 - *2023-03-15*

* Standardise files with files in sous-chefs/repo-management

## 2.0.10 - *2023-03-02*

* Standardise files with files in sous-chefs/repo-management

## 2.0.9 - *2023-02-23*

* Standardise files with files in sous-chefs/repo-management

## 2.0.8 - *2023-02-16*

* Standardise files with files in sous-chefs/repo-management

## 2.0.7 - *2023-02-15*

* Standardise files with files in sous-chefs/repo-management

## 2.0.6 - *2023-02-14*

* Remove CircleCI

## 2.0.5 - *2022-12-13*

* Standardise files with files in sous-chefs/repo-management

## 2.0.4 - *2022-02-03*

* Standardise files with files in sous-chefs/repo-management

## 2.0.3 - *2022-02-02*

* Fix `cert_path` usage when using `create_subfolders`
* Remove delivery and move to calling RSpec directly via a reusable workflow
* Update tested platforms

## 2.0.2 - *2021-08-30*

* Standardise files with files in sous-chefs/repo-management

## 2.0.1 - *2021-07-09*

* Standardise files with files in sous-chefs/repo-management

## 2.0.0 - *2021-07-06*

* Sous Chefs Adoption

## 1.0.0 - 2015-04-03

* #45 @dmlb2000 added `data_bag_type` parameter and support for vault, or unencrypted modes.
* Update documentation for helper methods.

## 0.8.2 - 2015-03-02

* #43 @hartfordfi## e added sensitive mode to hide certificates and keys in console output.
* #47 @fletchowns added documentation note concerning lazy attribute evaluation.

## 0.8.1 - 2015-02-05

* Fix bad pick on merge conflict from revert.

## 0.8.0 - 2015-02-04

* Revert #38: This previous change worked around a bug in Knife that limited use of characters in data bags. See
  [CHEF-3531](https://github.com/chef/chef/pull/1104) for more information.

## 0.7.0 - 2015-01-23

* #33 expose final path of managed objects.
* #38 normalize dots to underscore in search_id
* #40 chefspec matcher deprecation
* Update travis config

## v0.6.3

* #30 Hash rockets
* #34 Rescue version

## v0.6.0

* Add thor-scmversion
* Add use_inline_resources, if defined
* Add ignore_missing parameter

## v0.5.2

* Update documentation
* Update gitignore
* Rubocop whitespace corrections

## v0.5.0

* ChefSpec create_certificate_manage matcher added.
* Added combined_file resource.
* Update build files.
* Added Rubocop.
* Added BATS tests.

## v0.4.3

* Issue #16, fix handling of subdir creation

## v0.4.2

* Issue #15, Revert FC017 change

## v0.4.1

* FC017: LWRP does not notify when updated: ./providers/manage.rb:24

## v0.4.0

* Add `nginx_cert` knob for chained certificates

## v0.3.0

* Add test-kitchen coverage and documentation.

## v0.2.3

* Fix typo in "manage" resource definitions

## v0.2.2

* Add :create_subfolders attribute, to toggle off folder creation of private/certs directories.

## v0.2.1

* Fixes issue #11, reported by @tmatilia

## v0.2.0

Cleaning up the backlog of PRs

* @kechagia added data_bag_secret attribute
* @sawanoboly added smartos paths, and recipe `certificate::manage_by_attributes`
* allow specification of data bag secret
  * new attribute added: data_bag_secret
  * defaults to /etc/chef/encrypted_data_bag_secret
* openssl certs path for smartos
* add recipe manage_by_attributes
* Add :data_bag_keyfile attribute to the LWRP.

## v0.1.0

Thanks Teemu, and Kris, for their outstanding work!

* Teemu Matilainen
  * Add whyrun mode support.
  * Extract directory and file creation to generic methods.
  * Corrected outstanding issues related to updated_by_last_action

* Kris Kechagia
  * Corrected the updated_by_last_action to avoid unneccessary
    notification.

## 0.0.6

* Fix incorrect has_key conditional
* Disable incorrect foodcritic warning about repetition

## 0.0.5

* Add foodcritic linting
* Anyone have ideas on testing LWRPs?

## 0.0.4

* Fix default action

## 0.0.3

* Minor typo fixes

## 0.0.2

* LWRP conversion of recipe

## 0.0.1

* Recipe prototype
