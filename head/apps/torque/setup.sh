#!/bin/bash

# Fill in the nodes that go into the nodes list file under /var/spool.
# Format is <hostname><space>np=<number of processors>
TORQUE_NODES=("node01.cluster np=4" "node02.cluster np=4")

# Install the required packages for building Torque
yum install openssl-devel boost-devel libxml2-devel -y

# Compile, configure and install procedure for Torque
rm -rf /tmp/torque
cd /tmp
git clone https://github.com/adaptivecomputing/torque.git torque
cd torque
./autogen.sh

# Configure/compile/install
./configure
make -j $CORES
libtool --finish /usr/local/lib
make install

# Set up the required configs
echo $HOSTNAME > /var/spool/torque/server_name
echo "/usr/local/lib" > /etc/ld.so.conf.d/torque.conf
ldconfig
printf "%s\n" "${TORQUE_NODES[@]}" > /var/spool/torque/server_priv/nodes

# Install and start the remaining configs
cp contrib/systemd/trqauthd.service /usr/lib/systemd/system/
systemctl enable trqauthd.service
systemctl start trqauthd.service
./torque.setup root
/usr/local/bin/qterm
cp contrib/systemd/pbs_server.service /usr/lib/systemd/system/
systemctl enable pbs_server.service
systemctl start pbs_server.service

# Getting the packages to the compute nodes
make packages
