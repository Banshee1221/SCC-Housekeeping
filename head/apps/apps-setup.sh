#!/bin/bash

# List of all the user apps to install.
# This needs to be the same as the folders in the directory. Case sensitive.
export ORIG_DIR=$(pwd)
INSTALL_LIST=(
  "openMPI"
  "torque"
  )

# Install initializer
for each in ${INSTALL_LIST[@]}
do
  callscript "$each" "setup.sh"
done
