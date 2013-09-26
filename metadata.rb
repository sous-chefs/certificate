name             "certificate"
maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs/Configures certificates, private keys, CA root bundles from encrypted data bags."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4.3"
%w( amazon centos debian fedora redhat oracle scientific ubuntu smartos ).each do |os|
  supports os
end
