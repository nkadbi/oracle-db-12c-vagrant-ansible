# oracle-db-12c-vagrant-ansible
Start using Vagrant and Ansible to get your Oracle Infrastructure up an running, CentOS 7.2, Oracle 12c
## Description:
This projects includes an example Vagrantfile and Ansible playbook to setup two
Virtual servers with CentOS 7.2

Oracle Database 12.1.0.2 

  - dbserver1 | IP 192.168.56.31 | DB1 | single-tenant |  with additional disks a 8GB: dbserver1_disk_a.vdi,dbserver1_disk_b.vdi
  - dbserver2 | IP 192.168.56.32 | DB2 |  CDB with PDB  | with additional disks a 8GB: dbserver1_disk_a.vdi,dbserver1_disk_b.vdi


## Requirements
Oracle VirtualBox

Ansible  2.2.0.0, 

Vagrant 1.8.5 with plugin hostmanager [  vagrant plugin install vagrant-hostmanager ]

Network Connection

Space Requirements:
10 GB (including virtual disks and 2.6 GB for Oracle Binaries )

Tested on LAPTOP with 16 GB RAM, LINUX Kernel 4.4.0-57, SSD Disks, OracleVirtualBox 5.1.12, vagrant 1.8.5, ansible 2.2.0.0

→ takes about 20 minutes to bring up 2 virtual servers with installed DB

More Details in my blog: ..coming soon ...

## USAGE
checkout from github
git clone https://github.com/nkadbi/oracle-db-12c-vagrant-ansible

The Git Repository does not include the Oracle Software
please copy Oracle software files into the download folder
```ruby
linuxamd64_12102_database_1of2.zip
linuxamd64_12102_database_2of2.zip
```
## Custom variables
you can adapt variables for your needs.

General Variables for all Servers Containing Oracle Database
```ruby
group_vars/dbserver
```
Varaibles specified for one server, including database name, characterset etc.
These variables are used in response file to create database with dbca
```ruby
host_vars/dbserver1, 
host_vars/dbserver2  
```
## start provisioning
```ruby
vagrant up
```
connect to virtual server dbserver1
```ruby
vagrant ssh dbserver1
su - oracle  (password welcome1)
```


## Cleanup
Delete VM’s and virtual disks
go to directory my-ora-ansible-proj
```ruby
vagrant destroy
```

## Main Configutaion files

### Vagrantfile – used to configure setup of virtual servers with vagrant
```ruby
...
using vm.box = "boxcutter/centos72"
plungin hostmanger used: config.hostmanager.enabled = true
# Use the same insecure key provided from box for each machine , !!! do not use for production !!!!
config.ssh.insert_key = false 
...
```

#### Ansible Playbook 

my-ora-ansible-proj with Roles:

  - disk_layout  ->  Partitioning and Filesystem Creation
    
  - linux_oracle ->  Prepare Linux Server for Oracle Installation
 
  - oracle_sw_install -> install Oracle Home , template to create response file:  db_install.rsp.j2
   
  - oracle_db_create ->  creates database from seed template, creates listener, create oracle service
