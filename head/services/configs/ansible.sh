#!/bin/bash

# Create entries for all the nodes, excluding the headnode
IFS=',' read -a arr <<< "$NODELIST_COMP"
echo "[nodes]" > /etc/ansible/hosts
for items in ${arr[@]}
do
       printf "$items\n" >> /etc/ansible/hosts
done
sed -i "/$HOSTNAME/d" /etc/ansible/hosts
