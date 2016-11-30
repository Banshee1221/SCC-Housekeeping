#!/bin/bash

sudo yum install -y bunzip2
ATLAS_VER="3.10.3"
ATLAS_PKG="atlas"
ATLAS_EXT="tar.bz2"
ATLAS_PKG_NAME=$ATLAS_PKG$ATLAS_VER
ATLAS_PKG_FULL=$ATLAS_PKG_NAME.$ATLAS_EXT
ATLAS_URL="http://downloads.sourceforge.net/project/math-atlas/Stable/$ATLAS_VER/$ATLAS_PKG_FULL"

wget $ATLAS_URL
bunzip2 -c $ATLAS_PKG_FULL | tar xfm -
