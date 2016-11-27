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

callscript "services/system" "selinux.sh"

callscript "services/system" "network.sh"
