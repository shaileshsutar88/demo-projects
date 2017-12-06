# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  #config.vm.define "base" do |machine|
  #  machine.vm.box = "ubuntu/xenial64"

  #  machine.vm.provision "ansible" do |ansible|
  #    ansible.playbook = "base-install.yml"
  #  end
  #end

  config.vm.define "web" do |machine|
    machine.vm.box = "ubuntu/xenial64"

  config.vm.network :forwarded_port, guest: 80, host: 8080  

    machine.vm.provision "ansible" do |ansible|
      ansible.verbose = "v"
      ansible.playbook = "web-role.yml"
      ansible.extra_vars = {
        ansible_python_interpreter: "/usr/bin/python3.5",
      }
    end
  end

  #config.vm.define "mongodb" do |machine|
  #  machine.vm.box = "bento/centos-6.9"

  #  machine.vm.provision "ansible" do |ansible|
  #    ansible.playbook = "mongodb-role.yml"
  #    ansible.extra_vars = {
  #      atlas_enabled: false
  #    }
  #  end
  #end
end