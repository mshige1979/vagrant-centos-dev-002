# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # common settings
  box_name = "centos64_01"
  box_url = "https://dl.dropboxusercontent.com/u/36773763/vagrant/CentOS-6.4-x86_64-v20130427.box"

  # vm1
  config.vm.define :vm1 do|vm1|
    # box 
    vm1.vm.box = box_name
    vm1.vm.box_url = box_url
    
    # network
    vm1.vm.network "private_network", ip: "192.168.50.111"

    # share
    vm1.vm.synced_folder "./data1", "/vagrant", \
        create: true, owner: 'vagrant', group: 'vagrant', \
        mount_options: ['dmode=777,fmode=666']

    # provision
    vm1.vm.provision :shell, :path => "./data1/script.sh"

  end

  # vm2
  config.vm.define :vm2 do|vm2|
    # box
    vm2.vm.box = box_name
    vm2.vm.box_url = box_url

    # network
    vm2.vm.network "private_network", ip: "192.168.50.112"

    # share
    vm2.vm.synced_folder "./data2", "/vagrant", \
        create: true, owner: 'vagrant', group: 'vagrant', \
        mount_options: ['dmode=777,fmode=666']

    # provision
    vm2.vm.provision :shell, :path => "./data2/script.sh"

  end

  # vm3
  config.vm.define :vm3 do|vm3|
    # box
    vm3.vm.box = box_name
    vm3.vm.box_url = box_url

    # network
    vm3.vm.network "private_network", ip: "192.168.50.113"

    # share
    vm3.vm.synced_folder "./data3", "/vagrant", \
        create: true, owner: 'vagrant', group: 'vagrant', \
        mount_options: ['dmode=777,fmode=666']

    # provision
    vm3.vm.provision :shell, :path => "./data3/script.sh"

  end

end
