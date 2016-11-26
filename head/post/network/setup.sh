### Copy over hosts configuration to compute nodes and set correct nameserver
ansible nodes -m copy -a "src=/etc/hosts dest=/etc/hosts"
ansible nodes -m shell -a "echo 'nameserver $STATIC_IP_HEAD' > /etc/resolv.conf"
ansible nodes -m shell -a "chattr +i /etc/resolv.conf"
