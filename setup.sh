#!/bin/bash

####
#
# Variables for config
#
####

# This is for hosts file creation. Enter all the aliases for each. Below is an example
 
NODELIST=("head.cluster" "head" "node01.cluster" "node01" "node02.cluster" "node02")	# List of node hostnames including head node
NODE_IPS=("10.0.0.10" "10.0.0.10" "10.0.0.11" "10.0.0.11" "10.0.0.12" "10.0.0.12")	# List of node IPs in order of above node list
export NODELIST_COMP=("head.cluster" "node01.cluster" "node02.cluster")			# List of node hostnames for script use. DON'T DUPE HOSTS

# Host only
EXTERNAL_NIC=eno16777984		# External network interface
INTERNAL_NIC=eno33557248		# Internal netowkr interface
export STATIC_IP_HEAD=10.0.0.10		# Static IP for the headnode
export CORES=2				# Headnode cores (for building)

export CLUSTER_USER=cluster		# Name of the shared/common user account (non-root)			
####
#
# GENERAL HOUSE KEEPING 
#
###

#yum update -yi
#yum install wget -y
#mkdir tmp
#cd tmp
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#rpm -Uvh epel-release-latest-7.noarch.rpm
#cd -
#rm -rf tmp
#yum update -y
#yum install docker chrony ansible git -y
#yum groupinstall 'Development Tools' -y
#iptables -F
#ldconfig

####
#
# Network configuration
#
####

#mkdir -p /etc/sysconfig/network-scripts/backup


#if [ -f "/etc/sysconfig/network-scripts/backup/ifcfg-$EXTERNAL_NIC.bak" ]
#then
#	echo "Backup for External NIC exists, skipping backup."
#else
#	mv /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC /etc/sysconfig/network-scripts/backup/ifcfg-$EXTERNAL_NIC.bak
#fi

#rm -rf /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
#touch /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
#cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
#TYPE=Ethernet
#BOOTPROTO=dhcp
#DEFROUTE=yes
#PEERDNS=yes
#PEERROUTES=yes
#IPV4_FAILURE_FATAL=no
#IPV6INIT=no
#NAME=$EXTERNAL_NIC
#DEVICE=$EXTERNAL_NIC
#ONBOOT=yes
#EOT


#if [ -f "/etc/sysconfig/network-scripts/backup/ifcfg-$INTERNAL_NIC.bak" ]
#then
#        echo "Backup for Internal NIC exists, skipping backup."
#else
#        mv /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC /etc/sysconfig/network-scripts/backup/ifcfg-$INTERNAL_NIC.bak
#fi

#rm -rf /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
#touch /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
#cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
#TYPE=Ethernet
#BOOTPROTO=static
#IPADDR=$STATIC_IP_HEAD
#NETMASK=255.255.255.0
#NM_CONTROLLED=no
#DEFROUTE=yes
#PEERDNS=yes
#PEERROUTES=yes
#IPV4_FAILURE_FATAL=no
#IPV6INIT=no
##NAME=$INTERNAL_NIC
#DEVICE=$INTERNAL_NIC
#ONBOOT=yes
#EOT

#systemctl restart network.service

#VAL=0
#for items in ${NODE_IPS[@]}
#do 
#	printf "$items\t${NODELIST[$VAL]}\n" >> /etc/hosts
#	((VAL++))
#done
#VAL=0

#echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
#sysctl -p /etc/sysctl.conf

####
#
# Ansible hosts config
#
####

#echo "[nodes]" > /etc/ansible/hosts
#for items in ${NODELIST_COMP[@]}
#do 
#       printf "$items\n" >> /etc/ansible/hosts
#done

#####
#
# Set up chrony
#
####

cp files/chrony.conf /etc

systemctl enable chronyd
systemctl start chronyd

chronyc -a makestep


####
#
# Set up Torque Scheduler
#
####

#bash apps/torque.sh

printf "==========\n=\n=\n=\n=\n= Make sure that you configure the networking on the compute nodes at this point\n=\n=\n=\n=\n==========\n"

read -r -p "Have you done this [y/N] " response
case $response in
    [yY][eE][sS]|[yY]) 
        printf "Continuing.\n\n"
        ;;
    *)
        exit
        ;;
esac

echo -e  'y\n'|ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
sudo -H -u $CLUSTER_USER bash -c "echo -e  'y\\n'|ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa"

for items in ${NODELIST_COMP[@]}
do 
	ssh-copy-id $items
	sudo -H -u $CLUSTER_USER bash -c "ssh-copy-id $items"
done

