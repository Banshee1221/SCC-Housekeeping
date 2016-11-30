#!/bin/bash

#download and configure gsl
./gsl.sh

#Assumes that openMPI is already installed

#download and configure fftw
./fftw.sh

#gadget itself
./gadget.sh
