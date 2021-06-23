name 'certificate'
maintainer 'Eric G. Wolfe'
maintainer_email 'eric.wolfe@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures certificates, private keys, CA root bundles from encrypted data bags.'
begin
  version IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
rescue
  '0.0.1'
end
%w( amazon centos debian fedora redhat oracle scientific ubuntu smartos ).each do |os|
  supports os
end

depends 'chef-vault'

name             'certificate'
source_url       'https://github.com/sous-chefs/certificate'
issues_url       'https://github.com/sous-chefs/certificate/issues'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
chef_version     '>= 15.3'
license          'Apache-2.0'
description      'Installs and configures certificates, private keys, CA root bundles from encrypted data bags.'
version          '1.0.0'

supports 'amazon'
supports 'arch'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'freebsd'
supports 'opensuse'
supports 'opensuseleap'
supports 'redhat'
supports 'scientific'
supports 'suse'
supports 'ubuntu'

depends 'chef-vault'
