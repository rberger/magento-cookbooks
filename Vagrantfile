Vagrant::Config.run do |config|
  config.vm.box = "maverick32"

  # Debug
  #config.vm.boot_mode = :gui
  
  config.vm.customize do |vm|
    vm.memory_size = 512
    vm.name = "Magento Dev"
  end
 
  # Enable host-only networking, see http://vagrantup.com/docs/host_only_networking.html
  config.vm.network("33.33.33.33")

  config.vm.host_name = "magento.dev"

  # Enable provisioning with chef solo
  config.vm.provision :chef_solo do |chef|
    #chef.recipe_url = "http://cloud.github.com/downloads/tonigrigoriu/magento-cookbooks/cookbooks.tgz"
    chef.cookbooks_path = "."
    chef.add_recipe("vagrant-main")
    
    chef.json.merge!({
      :mysql => {
        :server_root_password => "root"
      },
      :ubuntu => {
        :archive_url => "http://de.archive.ubuntu.com/ubuntu"
      },
      :nfs => {
        :exports => {
           "/var/www" => {
             :nfs_options => "33.33.33.1(rw,async,all_squash,anonuid=1000,anongid=1000,no_subtree_check,insecure)"
           }
        } 
      }
    })

    # Debug
    #chef.log_level = :debug
  end
end
