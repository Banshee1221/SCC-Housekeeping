#!/bin/bash

# OpenMPI variables
GLOBAL_VER="v2.0"
OMPI_VER="2.0.1"
OMPI_PKG="openmpi-$OMPI_VER.tar.gz"
URL=https://www.open-mpi.org/software/ompi/$GLOBAL_VER/downloads/OMPI_PKG

# Get the packages
cd tmp
wget $URL
tar zxvf $OMPI_PKG
cd $OMPI_PKG

# Configure/compile/install
./configure --prefix=/usr/local
make -j $CORES all
make install
ldconfig
