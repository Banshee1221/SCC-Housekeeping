#!/bin/bash

yum install pexpect python-pip -y

pip install --upgrade pip

pip install pexpect --upgrade

# Create entries for all the nodes, excluding the headnode
IFS=',' read -a arr <<< "$NODELIST_COMP"
echo "[nodes]" > /etc/ansible/hosts
for items in ${arr[@]}
do
       printf "$items\n" >> /etc/ansible/hosts
done
sed -i "/$HOSTNAME/d" /etc/ansible/hosts
