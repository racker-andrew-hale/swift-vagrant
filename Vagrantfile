# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

# read local config values.
local_config = 'local.yaml'
if !File.exist?(local_config)
    abort("local.yaml not found, please run: ./config")
end
settings = YAML.load_file local_config

Vagrant.configure("2") do |config|

  # Load Balancer Nodes
  (1..1).each do |i|
    hostname = "lb#{i}"
    config.vm.define hostname do |proxy|
      proxy.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      proxy.vm.box = "trusty64"
      proxy.vm.hostname = hostname
      proxy.vm.synced_folder "salt", "/srv/salt/"


      proxy.vm.network :private_network, ip: "#{settings['general']['network']}.100"
      proxy.vm.network :forwarded_port, guest: 8080, host: settings['lb']['host_port']

      proxy.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end
      proxy.vm.provision :salt do |salt|
        salt.masterless = true
        salt.minion_config = "salt/minion/conf"
        salt.grains_config = "salt/minion/grains/lb"
        salt.run_highstate = true
        salt.bootstrap_options = '-F -c /tmp/ -P'
      end
    end
  end

  # Proxy Nodes
  (1..settings['proxy']['count']).each do |i|
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
  (1..settings['storage']['count']).each do |i|
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
	v.customize ["storagectl", :id, "--name", "SATAController", "--portcount", 11]

        (1..10).each do |j|
          file_to_disk = "./tmp/#{hostname}-d#{j}.vdi"
          unless File.exist?(file_to_disk)
            v.customize ['createhd', '--filename', file_to_disk, '--size', 400 * 1024]
          end
        end
        # TODO: figure out why this does not work in a loop...
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d1.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d2.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d3.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d4.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 5, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d5.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 6, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d6.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 7, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d7.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 8, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d8.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 9, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d9.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 10, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d10.vdi"]
      end
    end
  end
end
