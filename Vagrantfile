# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "proxy-z1" do |proxy|
    proxy.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    proxy.vm.box = "trusty64"
    proxy.vm.hostname = 'proxy-z1'

    proxy.vm.network :private_network, ip: "10.0.0.100"
    proxy.vm.network :forwarded_port, guest: 8080, host: 8080

    proxy.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "proxy-z1"]
    end
  end


  # file_to_disk = './tmp/large_disk.vdi'
  # TODO: change this to create 4 storage nodes when it works for 1.
  (1..1).each do |i|
    config.vm.define "storage-z#{i}" do |storage|
      storage.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      storage.vm.box = "trusty64"
      storage.vm.hostname = 'db'

      storage.vm.network :private_network, ip: "10.0.0.10#{i}"

      storage.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", "storage-z#{i}"]
        # v.customize ['createhd', '--filename', file_to_disk, '--size', 400 * 1024]
        # v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      end
    end
  end
end
