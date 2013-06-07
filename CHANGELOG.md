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

commit 792744c7bc793ac733d2cf9c20438db4fb23f0df
Author: kris kechagia <kk@rndsec.net>
Date:   Fri Dec 14 10:10:23 2012 +0100

    allow specification of data bag secret
    
      - new attribute added: data_bag_secret
      - defaults to /etc/chef/encrypted_data_bag_secret

commit 173abfd91e49f534ad04f7df517c937529bc4f0a
Author: sawanoboly <sawanoboriyu@higanworks.com>
Date:   Mon Mar 11 17:21:26 2013 +0900

    openssl certs path for smartos

commit e7808b35e710c76b8c3abd3366b950e0f75cf754
Author: sawanoboly <sawanoboriyu@higanworks.com>
Date:   Wed Feb 13 12:32:01 2013 +0900

    add recipe manage_by_attributes

commit 47b8ef2f28c716e2cfa3e301930b0c1d290391c9
Author: William McVey <wam@cisco.com>
Date:   Fri Dec 7 15:44:37 2012 -0500

    Add :data_bag_keyfile attribute to the LWRP.
    
    If :data_bag_keyfile is specified in the resource, it will point to
    an alternate filename in which the encryption key associated with the
    encrypted databag is stored. If it is not specified, the Chef default
    behavior of attempting to use Chef::Config[:encrypted_data_bag_secret]
    or then "/etc/chef/encrypted_data_bag_secret"

## v0.1.0

Thanks Teemu, and Kris, for their outstanding work!

* Teemu Matilainen
  - Add whyrun mode support.
  - Extract directory and file creation to generic methods.
  - Corrected outstanding issues related to updated_by_last_action
   
* Kris Kechagia
  - Corrected the updated_by_last_action to avoid unneccessary
    notification.

## v0.0.6

  - Fix incorrect has_key conditional
  - Disable incorrect foodcritic warning about repetition

## v0.0.5

  - Add foodcritic linting
  - Anyone have ideas on testing LWRPs?

## v0.0.4

  - Fix default action

## v0.0.3

  - Minor typo fixes

## v0.0.2

  - LWRP conversion of recipe

## v0.0.1

  - Recipe prototype
