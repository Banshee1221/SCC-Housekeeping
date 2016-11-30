#!/bin/bash

GADGET_VER="2.0.7 "
GADGET_PKG="gadget"
GADGET_EXT="tar.gz"
GADGET_PKG_NAME=$GADGET_PKG-$GADGET_VER
GADGET_PKG_FULL=$GADGET_PKG_NAME.$GADGET_EXT
GADGET_URL="http://wwwmpa.mpa-garching.mpg.de/$GADGET_PKG/$GADGET_PKG_FULL"

wget $GADGET_URL
tar -xzf $GADGET_PKG_FULL
cp ./Makefile Gadget-$GADGET_VER/Gadget2/.
cd Gadget-$GADGET_VER/Gadget2
make
