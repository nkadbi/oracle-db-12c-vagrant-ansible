# -*- mode: ruby -*-
# vi : set ft=ruby :

Vagrant.configure(2) do |config|

  config.ssh.insert_key = false # Use the same insecure key provided from box for each machine
  config.vm.box = "boxcutter/centos72" 
  config.vm.box_check_update = false # do not check for updates  ( not recommended , just for demo )
  config.vm.boot_timeout = 700
  config.hostmanager.enabled = true
  config.hostmanager.ignore_private_ip = false
   
   N = 2  
   (1..2).each do |i| # do for each server i
     config.vm.define "dbserver#{i}" do |config|  # do on node i
     config.vm.hostname = "dbserver#{i}"
     puts " dbserver#{i}  "
     config.vm.network "private_network", ip: "192.168.56.3#{i}"
     config.vm.provider "virtualbox" do |v| # virtual box configuration
       v.memory = "3072"
       v.cpus = 2
        if ! File.exist?("dbserver#{i}_disk_a.vdi") # create disks only once 
           v.customize ['createhd', '--filename', "dbserver#{i}_disk_a.vdi", '--size', 8192 ]
           v.customize ['createhd', '--filename', "dbserver#{i}_disk_b.vdi", '--size', 8192 ]
           v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "dbserver#{i}_disk_a.vdi"]
           v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "dbserver#{i}_disk_b.vdi"]
        end #  create disks only once 
     end # end virtual box configuration

      # Vagrant is designed for serial execution for multiple machines
      # if you want to take advantage from ansible parallel execution 
      # look at www.vagrantup.com/docs/provisioning/ansible.html 
      # we start provisioning only when all servers are up (i=N)
         if i == N
              config.vm.provision "ansible" do |ansible|  # vm.provisioning
                ansible.playbook = "oracle-db.yml"
                ansible.inventory_path = "./hosts"
                # when using an inventory file, the path to the private key must also be specified
                # either  in the inventory file itself like:
                # ansible_ssh_private_key_file=./.vagrant/machines/default/virtualbox/private_key
                # or as argument:
                #ansible.raw_arguments  = [
                #  "--private-key=./.vagrant/machines/default/virtualbox/private_key"
                #]
                # Disable default limit to connect to all the machines
                ansible.limit = 'all'
                ansible.groups = {
                   "group1" => ["dbserver"]
                 }
               end # end vm.provisioning 
         end # end if

     end # do on node i
   end # for each server i

end  # end Vagrant.configure(2)
