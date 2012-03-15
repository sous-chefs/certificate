maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs/Configures certificates, private keys, CA root bundles from encrypted data bags."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"
%w( amazon centos debian fedora redhat scientific ubuntu ).each do |os|
  supports os
end
