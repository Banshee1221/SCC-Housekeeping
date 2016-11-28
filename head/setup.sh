#!/bin/bash

# Pull in config variables
source ../vars

# Functions
callscript () {
  cd $1
  bash $2
  cd -
}
export -f callscript

#: <<'END'

# First run
if [ -f "./deleteme" ]
then
  echo "Starting...."
  sleep 3
else
  printf "Please go through the apps directory and ensure that all the variables"
  printf " have been correctly set for this machines setup.\n"
  touch deleteme
  exit
fi


### Network configuration
callscript "services" "system/network.sh"

### General system prep
yum update -y && yum install wget -y
cd /tmp
rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
cd -
yum update -y && yum groupinstall 'Development Tools' -y
ldconfig
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

### Set up host services
printf "Set up the compute node scripts now, the next sections needs compute"
printf "network configured. Waiting 15 seconds.\n"
sleep 15
callscript "services" "service-setup.sh"

################ NETWORK CONFIG FOR COMPUTE NODES MUST BE DONE #################

printf "==========\n=\n=\n=\n=\n= Make sure that you have run the network setup"
printf " scripts on the compute nodes at this point.\n= !!!!!!MAKE SURE THEY'VE"
printf " REBOOTED!!!!!!\n=\n=\n=\n=\n==========\n"

read -r -p "Have you done this [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
        printf "Continuing.\n\n"
        ;;
    *)
        exit
        ;;
esac

################################################################################

# Set up SSH
callscript "services" "system/ssh.sh"

# Call all post scripts (these generally rely on network to be configured)
cd ansible
ansible-playbook site.yml
cd -

# Apps local install
callscript "apps" "apps-setup.sh"

# Apps for network
cd ansible
ansible-playbook apps.yml
cd -

#END
