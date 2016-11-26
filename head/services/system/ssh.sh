#!/bin/bash

# Generate ssh key for root user and for local user
echo -e  'y\n'|ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
sudo -H -u $CLUSTER_USER bash -c "echo -e  'y\\n'|ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa"

# Copy pub keys to root and user accounts of the nodes
IFS=',' read -a arr <<< "$NODELIST_COMP"
for items in ${arr[@]}
do
	ssh-copy-id $items
	sudo -H -u $CLUSTER_USER bash -c "ssh-copy-id $items"
done
