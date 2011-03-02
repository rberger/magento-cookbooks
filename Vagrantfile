Vagrant::Config.run do |config|
  config.vm.box = "maverick32"

  config.vm.forward_port "http", 80, 8080

  config.vm.customize do |vm|
    vm.memory_size = 512
    vm.name = "Magento"
  end

  # Enable provisioning with chef solo
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "."
    chef.add_recipe("ubuntu-common")
    chef.add_recipe("magento");
    
    chef.json.merge!({
      :mysql => {
        :server_root_password => "root"
      },
      :ubuntu => {
        :archive_url => "http://de.archive.ubuntu.com/ubuntu"
      }
    })

    chef.log_level = :debug
  end

  config.vm.network("33.33.33.10")
  
  #config.vm.share_folder("v-root", "/vagrant", ".")
end
