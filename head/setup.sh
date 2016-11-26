#!/bin/bash

### Variables for config

# List of node hostnames including head node, including aliases
export NODELIST="head.cluster,head,node01.cluster,node01,node02.cluster,node02"

# List of node IPs in order of above node list
export NODE_IPS="10.0.0.10,10.0.0.10,10.0.0.11,10.0.0.11,10.0.0.12,10.0.0.12"

# List of node FQDN for script use. DON'T DUPE HOSTS
export NODELIST_COMP="head.cluster,node01.cluster,node02.cluster"

# External network interface
export EXTERNAL_NIC="eno16777984"

# Internal netowkr interface
export INTERNAL_NIC="eno33557248"

# Static IP for the headnode
export STATIC_IP_HEAD="10.0.0.10"

# Headnode cores (for building)
export CORES=2

# Name of the shared/common user account (non-root)
export CLUSTER_USER="cluster"

# Directory to export for NFS
export NFS_DIRS="/scratch,/home"

# Functions
callscript () {
  cd $1
  bash $2
  cd -
}
export -f callscript

# First run
if [ -f "./deleteme" ]
then
  echo "Starting...."
  sleep 3
else
  printf "Please go through the apps directory and ensure that all the variables"
  printf " have been correctly set for this machines setup.\n"
  touch deleteme
fi


### Network configuration
callscript "services" "system/network.sh"

### General system prep
yum update -y
yum install wget -y
cd /tmp
rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
cd -
yum update -y
yum groupinstall 'Development Tools' -y
ldconfig
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

### Set up host services
printf "Set up the compute node scripts now, the next sections needs compute"
printf "network configured. Waiting 10 seconds.\n"
sleep 15
callscript "services" "service-setup.sh"

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

# Set up SSH
callscript "services" "system/ssh.sh"

### Copy over hosts configuration to compute nodes and set correct nameserver
ansible nodes -m copy -a "src=/etc/hosts dest=/etc/hosts"
ansible nodes -m shell -a "echo 'nameserver $STATIC_IP_HEAD' > /etc/resolv.conf"
ansible nodes -m shell -a "chattr +i /etc/resolv.conf"

# Apps install
#bash apps/app-setup.sh
