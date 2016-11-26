#!/bin/bash

# Flush all iptables rules
iptables -F

# Create backup directory for original NIC configs
mkdir -p /etc/sysconfig/network-scripts/backup

# Check if a backup has already been made for outward and inward facing NICs
# External NIC
if [ -f "/etc/sysconfig/network-scripts/backup/ifcfg-$EXTERNAL_NIC.bak" ]
then
  echo "Backup for External NIC exists, skipping backup."
else
  mv /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC \
    /etc/sysconfig/network-scripts/backup/ifcfg-$EXTERNAL_NIC.bak
fi
# Internal NIC
if [ -f "/etc/sysconfig/network-scripts/backup/ifcfg-$INTERNAL_NIC.bak" ]
then
  echo "Backup for Internal NIC exists, skipping backup."
else
  mv /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC \
    /etc/sysconfig/network-scripts/backup/ifcfg-$INTERNAL_NIC.bak
fi

# Create the new config for the external NIC
rm -rf /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
touch /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-$EXTERNAL_NIC
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=$EXTERNAL_NIC
DEVICE=$EXTERNAL_NIC
ONBOOT=yes
EOT

# Create the new config for the internal NIC
rm -rf /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
touch /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
cat <<EOT >> /etc/sysconfig/network-scripts/ifcfg-$INTERNAL_NIC
TYPE=Ethernet
BOOTPROTO=static
IPADDR=$STATIC_IP_HEAD
NETMASK=255.255.255.0
NM_CONTROLLED=no
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
#NAME=$INTERNAL_NIC
DEVICE=$INTERNAL_NIC
ONBOOT=yes
EOT

# Restart the network service
systemctl restart network.service

# Add new hosts to the system host file
IFS=',' read -a arr1 <<< "$NODE_IPS"
IFS=',' read -a arr2 <<< "$NODELIST"
VAL=0
for items in ${arr1[@]}
do
	printf "$items\t${arr2[$VAL]}\n" >> /etc/hosts
	((VAL++))
done
VAL=0

# Enable IP forwarding for IPV4 network
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

# Enable NAT for external -> internal NIC routing
iptables -t nat -A POSTROUTING -o $EXTERNAL_NIC -j MASQUERADE
iptables -A FORWARD -i $EXTERNAL_NIC -o $INTERNAL_NIC -m state \
    --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $INTERNAL_NIC -o $EXTERNAL_NIC -j ACCEPT
iptables-save > /etc/sysconfig/iptables
