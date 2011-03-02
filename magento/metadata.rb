maintainer       "Toni Grigoriu"
maintainer_email "toni@grigoriu.ro"
license          "Apache 2.0"
description      "Installs/Configures Magento"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.7.2"
depends          "php"
depends          "apache2"
depends          "mysql"
depends          "openssl"

recipe "magento", "Installs and configures Magento LAMP stack on a single system"

%w{ debian ubuntu }.each do |os|
  supports os
end

attribute "magento/version",
  :display_name => "Magento download version",
  :description => "Version of Magento to download from the Magento site.",
  :default => "1.5.0.1"
  
attribute "magento/checksum",
  :display_name => "Magento tarball checksum",
  :description => "Checksum of the tarball for the version specified.",
  :default => "eb173239211e450e16a20dbc1a6f1e95ab2bda77644252ab531d26174a26b347"
  
attribute "magento/dir",
  :display_name => "Magento installation directory",
  :description => "Location to place magento files.",
  :default => "/var/www/magento"
  
attribute "magento/db/database",
  :display_name => "Magento MySQL database",
  :description => "Magento will use this MySQL database to store its data.",
  :default => "magento"

attribute "magento/db/user",
  :display_name => "Magento MySQL user",
  :description => "Magento will connect to MySQL using this user.",
  :default => "root"

attribute "magento/db/password",
  :display_name => "Magento MySQL password",
  :description => "Password for the Magento MySQL user.",
  :default => "randomly generated"

attribute "magento/keys/enc",
  :display_name => "Magento encryption key",
  :description => "Magento encryption key.",
  :default => "randomly generated"
