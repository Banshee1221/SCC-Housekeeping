#!/bin/bash

# List of services to be installed on the head node
INSTALL_LIST="
  docker
  chrony
  ansible
  nfs-utils libnfsidmap
"

# Install all listed apps
yum install -y $INSTALL_LIST

# chrony
bash configs/chrony.sh

# ansible
bash configs/ansible.sh

# Set up Torque Scheduler
bash configs/torque.sh
