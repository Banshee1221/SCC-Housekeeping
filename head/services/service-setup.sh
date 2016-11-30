#!/bin/bash

# List of services to be installed on the head node
INSTALL_LIST="
  chrony
  ansible
  nfs-utils libnfsidmap
  libselinux-python
  cmake
  expect
  gtk2
  kernel-devel
"

# Install all listed apps
yum install -y $INSTALL_LIST

# chrony
callscript "configs" "chrony.sh"

# ansible
callscript "configs" "ansible.sh"

# NFS
callscript "configs" "nfs.sh"
