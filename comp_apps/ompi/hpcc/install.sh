#!/bin/bash
set -e

sudo yum install -y atlas \
  atlas-devel \
  lapack \
  lapack-devel \
  lapack64 \
  lapack64-devel \
  scalapack-common \
  scalapack-openmpi \
  scalapack-openmpi-devel \
  scalapack-mpich \
  scalapack-mpich-devel \
  blas \
  blas-devel \
  blas64 \
  blas64-devel

HPCC_VER="1.5.0"
HPCC_PKG="hpcc"
HPCC_EXT="tar.gz"
HPCC_PKG_NAME=$HPCC_PKG-$HPCC_VER
HPCC_PKG_FULL=$HPCC_PKG_NAME.$HPCC_EXT
HPCC_URL="http://icl.cs.utk.edu/projectsfiles/$HPCC_PKG/download/$HPCC_PKG_FULL"

wget $HPCC_URL
tar zxf $HPCC_PKG_FULL
cd $HPCC_PKG_NAME
