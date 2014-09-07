certificate cookbook changelog
==============================

v0.6.3
------

* #30 Hash rockets
* #34 Rescue version

v0.6.0
------

* Add thor-scmversion
* Add use_inline_resources, if defined
* Add ignore_missing parameter

v0.5.2
------

* Update documentation
* Update gitignore
* Rubocop whitespace corrections 

v0.5.0
------

* ChefSpec create_certificate_manage matcher added.
* Added combined_file resource.
* Update build files.
* Added Rubocop.
* Added BATS tests.

v0.4.3
------

* Issue #16, fix handling of subdir creation

v0.4.2
------

* Issue #15, Revert FC017 change

v0.4.1
------

* FC017: LWRP does not notify when updated: ./providers/manage.rb:24

v0.4.0
------

* Add `nginx_cert` knob for chained certificates

v0.3.0
------

* Add test-kitchen coverage and documentation. 

v0.2.3
------

* Fix typo in "manage" resource definitions

v0.2.2
------

* Add :create_subfolders attribute, to toggle off folder creation of private/certs directories.

v0.2.1
------

* Fixes issue #11, reported by @tmatilia

v0.2.0
------

Cleaning up the backlog of PRs

* @kechagia added data_bag_secret attribute
* @sawanoboly added smartos paths, and recipe `certificate::manage_by_attributes`
* allow specification of data bag secret
  - new attribute added: data_bag_secret
  - defaults to /etc/chef/encrypted_data_bag_secret
* openssl certs path for smartos
* add recipe manage_by_attributes
*  Add :data_bag_keyfile attribute to the LWRP.

v0.1.0
------

Thanks Teemu, and Kris, for their outstanding work!

* Teemu Matilainen
  - Add whyrun mode support.
  - Extract directory and file creation to generic methods.
  - Corrected outstanding issues related to updated_by_last_action
   
* Kris Kechagia
  - Corrected the updated_by_last_action to avoid unneccessary
    notification.

v0.0.6
------

  - Fix incorrect has_key conditional
  - Disable incorrect foodcritic warning about repetition

v0.0.5
------

  - Add foodcritic linting
  - Anyone have ideas on testing LWRPs?

v0.0.4
------

  - Fix default action

v0.0.3
------

  - Minor typo fixes

v0.0.2
------

  - LWRP conversion of recipe

v0.0.1
------

  - Recipe prototype
