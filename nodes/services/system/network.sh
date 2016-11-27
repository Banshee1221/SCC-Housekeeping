#!/bin/bash

# Flush all iptables rules
iptables -F

# Create backup directory for original NIC configs
mkdir -p /etc/sysconfig/network-scripts/backup


# Internal NIC
if [ -f "/etc/sysconfig/network-scripts/backup/ifcfg-$COMP_INTERNAL_NIC.bak" ]
then
  echo "Backup for Internal NIC exists, skipping backup."
else
  mv /etc/sysconfig/network-scripts/ifcfg-$COMP_INTERNAL_NIC \
    /etc/sysconfig/network-scripts/backup/ifcfg-$COMP_INTERNAL_NIC.bak
fi

# Create the new config for the internal NIC
rm -rf /etc/sysconfig/network-scripts/ifcfg-$COMP_INTERNAL_NIC
touch /etc/sysconfig/network-scripts/ifcfg-$COMP_INTERNAL_NIC
cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-$COMP_INTERNAL_NIC
TYPE=Ethernet
BOOTPROTO=static
IPADDR=$STATIC_IP_COMP
NETMASK=255.255.255.0
NM_CONTROLLED=no
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=$COMP_INTERNAL_NIC
DEVICE=$COMP_INTERNAL_NIC
ONBOOT=yes
EOT

# Restart the network service
systemctl restart network.service
