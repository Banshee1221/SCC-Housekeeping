#!/bin/bash

# Fill in the nodes that go into the nodes list file under /var/spool.
# Format is <hostname><space>np=<number of processors>
NODES=("node01.cluster np=4" "node02.cluster np=4")

cd /tmp
git clone https://github.com/adaptivecomputing/torque.git torque
cd torque
./autogen.sh

./configure
make
make install

echo $HOSTNAME > /var/spool/torque/server_name
echo "/usr/local/lib" > /etc/ld.so.conf.d/torque.conf
ldconfig

printf "%s\n" "${NODES[@]}" > /var/spool/torque/server_priv/nodes

cp contrib/systemd/trqauthd.service /usr/lib/systemd/system/
systemctl enable trqauthd.service
systemctl start trqauthd.service
./torque.setup root
qterm
cp contrib/systemd/pbs_server.service /usr/lib/systemd/system/
systemctl enable pbs_server.service
systemctl start pbs_server.service

make packages
