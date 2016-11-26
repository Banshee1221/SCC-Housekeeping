#!/bin/bash

# OpenMPI variables
GLOBAL_VER="v2.0"
OMPI_VER="2.0.1"
OMPI_PKG="openmpi-$OMPI_VER"
OMPI_EXT="tar.gz"
URL=https://www.open-mpi.org/software/ompi/$GLOBAL_VER/downloads/$OMPI_PKG.$OMPI_EXT


# Get the packages
cd /tmp
wget $URL
tar zxf $OMPI_PKG
cd $OMPI_PKG

# Configure/compile/install
./configure --prefix=/usr/local
make -j $CORES all
make install
ldconfig

cd $ORIG_DIR
