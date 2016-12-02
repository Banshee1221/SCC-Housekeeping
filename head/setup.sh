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
  printf "\nPlease make sure all your variables are correct. PLEASE\n"
  touch deleteme
  exit
fi


### Network configuration
callscript "services" "system/network.sh"

### General system prep
yum install wget epel-release -y
yum update -y && yum groupinstall 'Development Tools' -y
ldconfig
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo setenforce 0

### Set up host services
printf "Set up the compute node scripts now, the next sections needs compute"
printf " network configured. Waiting 15 seconds.\n"
sleep 15
callscript "services" "service-setup.sh"

################ NETWORK CONFIG FOR COMPUTE NODES MUST BE DONE #################

printf "==========\n=\n=\n=\n=\n= Make sure that you have run the network setup"
printf " scripts on the compute nodes at this point.\n= !!!!!!MAKE SURE THEY'VE"
printf " REBOOTED!!!!!!\n=\n=\n=\n=\n==========\n"

response=0

prompt () {
read -r -p "Have you done this [y/N] " response
case $response in
  [yY][eE][sS]|[yY])
  printf "Continuing.\n\n"
  ;;
  [nN][oO]|[nN])
  exit 0
  ;;
  *)
  prompt
  ;;
esac
}

prompt

################################################################################

# Set up SSH
callscript "services" "system/ssh.sh"

# Call all post scripts (these generally rely on network to be configured)
cd ansible
ansible-playbook site.yml
cd -

# Apps install
cd ansible
ansible-playbook apps.yml
cd -

#END
