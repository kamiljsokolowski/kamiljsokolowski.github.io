# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
nodes = YAML.load_file('inventory.yml')

Vagrant.configure(2) do |config|

  nodes.each do |nodes|
      config.vm.define nodes["name"] do |node|
          node.vm.box = nodes["box"]
          node.vm.hostname = nodes["name"]
          node.vm.box_check_update = nodes["check_updates"]
          node.vm.network nodes["net"], ip: nodes["ip"]
          if nodes["ssh_host_port"] and nodes["ssh_guest_port"]
              node.vm.network "forwarded_port", guest: nodes["ssh_guest_port"], host: nodes["ssh_host_port"], id: 'ssh'
          end
          if nodes["forward_ports"]
            nodes["forward_ports"].each do |forwarded_port|
              node.vm.network "forwarded_port", guest: forwarded_port["guest_port"], host: forwarded_port["guest_port"]
            end
          end
          node.vm.provider "virtualbox" do |vb|
             vb.gui = nodes["gui"] || false
             vb.cpus = nodes["cpus"] || 1
             vb.memory = nodes["mem"] || 256
          end
          if nodes["privileged_scripts"]
            nodes["privileged_scripts"].each do |privileged_script|
              node.vm.provision "shell", path: privileged_script, privileged: true
            end
          end
          if nodes["scripts"]
            nodes["scripts"].each do |script|
              node.vm.provision "shell", path: script, privileged: false
            end
          end
      end
  end
end
