#!/bin/bash

# Create entries for all the nodes, excluding the headnode
echo "[nodes]" > /etc/ansible/hosts
for items in ${NODELIST_COMP[@]}
do
       printf "$items\n" >> /etc/ansible/hosts
done
sed -i "/$HOSTNAME/d" /etc/ansible/hosts
