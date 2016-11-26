# This is the repo for the bootstrap scripts for the cluster competition

## Features:

### Headnode

* Network
  * Configure local and external network
  * Edit hosts to include hostnames of nodes
  * Allow ip forwarding on IPv4
  * Create NAT rules with iptables and saves them

* System
  * Update packages
  * Enable EPEL repo
  * Install "Development Tools"
  * Disable SELINUX

* Services and config
  * docker
  * ansible
    * Create compute node list for ansible hosts /etc/ansible/hosts
  * chrony
    * Copy configuration of chrony to /etc
  * NFS
    * Create and export listings of NFS directories

* Communication
  * Generate SSH keys for root and user
  * Copy SSH keys of root and user to compute nodes (interactive only)

* Post
  * Copy hosts file to compute nodes
  * Set nameserver of compute nodes to IP of internal NIC of host
  * Make /etc/resolv.conf immutable on compute nodes

* Apps:
  * Compile apps from source and configure them
    * Torque (interactive)
    * OpenMPI

## TODO:

* Make copying of ssh-keys non-interactive
* Make torque setup non-interactive
