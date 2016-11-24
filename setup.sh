#!/bin/bash

####
#
# Variables for config
#
####

EXTERNAL_NIC=eno16777984		# External network interface
INTERNAL_NIC=eno33557248		# Internal netowkr interface
export STATIC_IP_HEAD=10.0.0.10		# Static IP for the headnode
export CORES=2				# Headnode cores (for building)

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

bash apps/torque.sh
