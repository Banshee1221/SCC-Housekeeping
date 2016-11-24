#!/bin/bash

### Variables for config

# This is for hosts file creation. Enter all the aliases for each. Below is an
# example
NODELIST=("head.cluster" "head" "node01.cluster" "node01" "node02.cluster" \    # List of node hostnames including head node
  "node02")
NODE_IPS=("10.0.0.10" "10.0.0.10" "10.0.0.11" "10.0.0.11" "10.0.0.12" \         # List of node IPs in order of above node list
  "10.0.0.12")
export NODELIST_COMP=("head.cluster" "node01.cluster" "node02.cluster")         # List of node hostnames for script use. DON'T DUPE HOSTS

# Host only
EXTERNAL_NIC=eno16777984		                                                    # External network interface
INTERNAL_NIC=eno33557248		                                                    # Internal netowkr interface
export STATIC_IP_HEAD=10.0.0.10		                                              # Static IP for the headnode
export CORES=2				                                                          # Headnode cores (for building)
export CLUSTER_USER=cluster		                                                  # Name of the shared/common user account (non-root)

### General system prep
yum update -y
yum install wget -y
mkdir tmp && cd tmp
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh epel-release-latest-7.noarch.rpm
cd - && rm -rf tmp
yum update -y
yum install docker chrony ansible git -y
yum groupinstall 'Development Tools' -y
iptables -F
ldconfig
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

### Network configuration
bash scripts/network.sh

### Ansible hosts config
bash scripts/ansible-conf.sh


################ NETWORK CONFIG FOR COMPUTE NODES MUST BE DONE #################

printf "==========\n=\n=\n=\n=\n= Make sure that you have run the network setup"
printf " scripts on the compute nodes at this point\n=\n=\n=\n=\n==========\n"

read -r -p "Have you done this [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
        printf "Continuing.\n\n"
        ;;
    *)
        exit
        ;;
esac

################################################################################

### SSH setup
bash scripts/ssh-setup.sh

### Copy over hosts configuration to compute nodes and set correct nameserver
ansible nodes -m copy -a "src=/etc/hosts dest=/etc/hosts"
ansible nodes -m shell -a "echo 'nameserver $STATIC_IP_HEAD' > /etc/resolv.conf"
ansible nodes -m shell -a "chattr +i /etc/resolv.conf"

### Set up compiled apps apps
bash scripts/apps-setup.sh
