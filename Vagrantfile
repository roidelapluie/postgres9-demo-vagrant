# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    # We define the first node
    config.vm.define :dupont do |dupont_config|
        dupont_config.vm.box = "CentOS-6.2-x86_64-minimal"
        dupont_config.vm.host_name = "dupont.demo"
        dupont_config.vm.network :hostonly, "192.168.142.31"
        dupont_config.vm.provision :puppet do |dupont_puppet|
            dupont_puppet.manifests_path = "manifests"
            dupont_puppet.manifest_file  = "site.pp"
            dupont_puppet.pp_path = "/vagrant"
            dupont_puppet.module_path = "./modules"
        end
        dupont_config.ssh.max_tries = 333
    end
    # We define the second node
    config.vm.define :dupond do |dupond_config|
        dupond_config.vm.box = "CentOS-6.2-x86_64-minimal"
        dupond_config.vm.host_name = "dupond.demo"
        dupond_config.vm.network :hostonly, "192.168.142.32"
        dupond_config.vm.provision :puppet do |dupond_puppet|
            dupond_puppet.manifests_path = "manifests"
            dupond_puppet.manifest_file  = "site.pp"
            dupond_puppet.pp_path = "/vagrant"
            dupond_puppet.module_path = "./modules"
        end
        dupond_config.ssh.max_tries = 333
    end
end
