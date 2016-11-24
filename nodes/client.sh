sudo apt-get install nfs-common -y
mkdir /mnt/cloud
sudo mount -t nfs 192.168.10.110:/mnt/cloud /mnt/cloud
df -h
echo "#MPI CLUSTER SETUP" >> /etc/fstab
echo "192.168.10.110:/mnt/cloud /home/kyle/cloud nfs" >> /etc/fstab

##########################CentOS7###########################
#yum install nfs-utils -y
#systemctl enable rpcbind
#systemctl enable nfs-server
#systemctl enable nfs-lock
#systemctl enable nfs-idmap
#systemctl start rpcbind
#systemctl start nfs-server
#systemctl start nfs-lock
#systemctl start nfs-idmap
#mkdir /mnt/cloud
#mount -t nfs 192.168.10.110:/mnt/cloud /mnt/cloud
#echo "192.168.0.100:/home    /mnt/nfs/home   nfs defaults 0 0" >> /etc/fstab
#echo "192.168.0.100:/var/nfsshare    /mnt/nfs/var/nfsshare   nfs defaults 0 0" >> /etc/fstab
