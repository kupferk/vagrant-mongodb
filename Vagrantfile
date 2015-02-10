# -*- mode: ruby -*-
# vi: set ft=ruby :

# You need to have the following vagrant plugins installed
#       vagrant-lxc
#       vagrant-hostmanager


LXC_BRIDGE = 'lxcbr0'


Vagrant.configure("2") do |config|
      config.vm.hostname = "mongodb"
      config.vm.box = "trusty64"
      config.vm.box_url = "http://files.vagrantup.com/trusty64.box"
      
      config.hostmanager.enabled = true
      config.hostmanager.manage_host = true
      config.hostmanager.ignore_private_ip = false
      config.hostmanager.include_offline = true      
      
      config.vm.provider :lxc do |lxc, override|
      	override.vm.box = "fgrehm/trusty64-lxc"
        override.vm.box_url = "https://atlas.hashicorp.com/fgrehm/boxes/trusty64-lxc/versions/1.2.0/providers/lxc.box"
        # override.vm.network :private_network, ip: opts[:ip], lxc__bridge_name: LXC_BRIDGE
        lxc.container_name = "mongodb"
        lxc.customize 'network.type', 'veth'
        lxc.customize 'network.link', LXC_BRIDGE
      end

      # install librarian-puppet and run it to install puppet common modules.
      # This has to be done before puppet provisioning so that modules are available
      # when puppet tries to parse its manifests
      config.vm.provision :shell, :path => "provision/scripts/main.sh"
      
      config.vm.provision :puppet do |puppet|
    	puppet.manifests_path = "provision/puppet/manifests"
        puppet.manifest_file = 'site.pp'
        puppet.module_path = [ 'provision/puppet/modules' ]
        puppet.options = "--verbose --debug"
      end
end

