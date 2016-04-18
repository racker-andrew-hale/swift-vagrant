# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Load Balancer Nodes
  (1..1).each do |i|
    hostname = "lb#{i}"
    config.vm.define hostname do |proxy|
      proxy.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      proxy.vm.box = "trusty64"
      proxy.vm.hostname = hostname

      proxy.vm.network :private_network, ip: "10.0.0.100"
      proxy.vm.network :forwarded_port, guest: 8080, host: 8080

      proxy.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end
    end
  end

  # Proxy Nodes
  (1..2).each do |i|
    hostname = "proxy-z#{i}"
    config.vm.define hostname do |proxy|
      proxy.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      proxy.vm.box = "trusty64"
      proxy.vm.hostname = hostname

      proxy.vm.network :private_network, ip: "10.0.0.100"

      proxy.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end
    end
  end

  # Storage Nodes
  (1..4).each do |i|
    hostname = "storage-z#{i}"
    config.vm.define hostname do |storage|
      storage.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      storage.vm.box = "trusty64"
      storage.vm.hostname = hostname

      storage.vm.network :private_network, ip: "10.0.0.20#{i}"

      storage.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]

        (1..10).each do |j|
          file_to_disk = "./tmp/#{hostname}-d#{j}.vdi"
          v.customize ['createhd', '--filename', file_to_disk, '--size', 400 * 1024]
          v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', i, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        end
      end
    end
  end
end
