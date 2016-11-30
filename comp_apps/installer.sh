#!/bin/bash
export GLOB_FALSE=false

check () {
  if [ GLOB_FALSE ];
  then
    echo -e  "ERROR: Error in another script occurred. Exiting."
    exit 1
  fi
}

runner () {
  dirs=`find . -type f -exec echo "{}" \; | grep $1 | grep install.sh | cut -d/ -f1,2,3`
  for items in ${dirs[@]}
  do
    echo $items
    cd ./$items/
    bash install.sh
    cd -
  done
}

printf "Which app suite do you want to install?\n\n"
printf "1. OMPI Suite\n"
printf "2. MPICH Suite\n"
printf "3. Intel Suite\n"
printf "\nSelection: "
read selection

if [ $selection == 1 ];
then
  printf "Installing OpenMPI app suite.\n"
  runner "ompi"
elif [ $selection == 2 ]
then
  printf "Installing MPICH app suite.\n"
  runner "mpich"
elif [ $selection == 3 ]
then
  printf "Installing Intel MPI suite.\n"
  runner "intel"
fi
