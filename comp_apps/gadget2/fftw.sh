#!/bin/bash

FFTW_VER="2.1.5"
FFTW_PKG="fftw"
FFTW_EXT="tar.gz"
FFTW_PKG_NAME=$FFTW_PKG-$FFTW_VER
FFTW_PKG_FULL=$FFTW_PKG_NAME.$FFTW_EXT
FFTW_URL="http://www.fftw.org/$FFTW_PKG_FULL"

wget $FFTW_URL
tar xfz $FFTW_PKG_FULL
cd $FFTW_PKG_NAME
./configure --enable-mpi --enable-type-prefix --enable-float
make
sudo make install
cd -
