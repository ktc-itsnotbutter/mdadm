name              "mdadm"
maintainer        "Opscode, Inc."
license           "Apache 2.0"
description       "Installs and configures mdadm raid devices"
version           "1.0.0"
recipe            "default", "Install and configure mdadm raid"

%w{ubuntu debian redhat centos scientific amazon fedora oracle smartos}.each do |os|
  supports os
end
