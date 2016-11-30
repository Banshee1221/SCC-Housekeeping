#!/bin/bash

GSL_VER="1.9"
GSL_PKG="gsl"
GSL_EXT="tar.gz"
GSL_PKG_NAME=$GSL_PKG-$GSL_VER
GSL_PKG_FULL=$GSL_PKG_NAME.$GSL_EXT
GSL_URL="http://mirror.rit.edu/gnu/$GSL_PKG/$GSL_PKG_FULL"


wget $GSL_URL
tar xfz $GSL_PKG_FULL
cd $GSL_PKG_NAME
./configure
make
sudo make install
cd -
