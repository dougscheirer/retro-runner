# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.network "private_network", ip: "192.168.44.10"

  # config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./vagrant", "/vagrant_data", type: "nfs"

  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant_data
    ./setup.sh
  SHELL
end
