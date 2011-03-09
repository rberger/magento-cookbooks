maintainer        "Toni Grigoriu"
maintainer_email  "toni@grigoriu.ro"
license           "Apache 2.0"
description       "Install variuos tools, e.g. ack-grep, htop etc"
version           "1.0.0"
recipe            "ubuntu_common", "Install various Ubuntu tools"

%w{ ubuntu debian }.each do |os|
  supports os
end
