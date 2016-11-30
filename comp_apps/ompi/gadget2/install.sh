#!/bin/bash
GLOB_FALSE=false

check () {
  if [ GLOB_FALSE ];
  then
    echo -e  "ERROR: Error in another script occurred. Exiting."
    exit 1
  fi
}

if [ -f .gsl_done ];
then
  echo -e  "===> gsl done, skipping."
else
  #download and configure gsl
  ./gsl.sh
  if [ ! $? == 1 ];
  then
    touch .gsl_done
  else
    echo -e  "\nERROR: GSL script failed!"
    GLOB_FALSE=true
  fi
fi

#Assumes that openMPI is already installed

check

if [ -f .fftw_done ];
then
  echo -e  "===> fftw done, skipping."
else
  #download and configure fftw
  ./fftw.sh
  if [ ! $? == 1 ];
  then
    touch .fftw_done
  else
    echo -e  "\nERROR: FFTW script failed!"
    GLOB_FALSE=true
  fi
fi

check

if [ -f .gadget_done ];
then
  echo -e  "===> fftw done, skipping."
else
  #gadget itself
  ./gadget.sh
  if [ ! $? == 1 ];
  then
    touch .gadget_done
  else
    echo -e  "\nERROR: FFTW script failed!"
    GLOB_FALSE=true
  fi
fi
