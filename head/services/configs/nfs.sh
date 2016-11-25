#!/bin/bash

# Enable the NFS services
systemctl enable rpcbind
systemctl enable nfs-server

# Start the NFS services
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start rpc-statd
systemctl start nfs-idmap

# Create export listing for the share
for each in ${NFS_DIRS[@]}
do
  echo "$each *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
done

# Export all shared FS
exportfs -a
