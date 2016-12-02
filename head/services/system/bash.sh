#!/bin/bashrc

printf "intel () {
source /scratch/intel/compilers_and_libraries_2017.1.132/linux/bin/compilervars.sh intel64
source /scratch/intel/impi/2017.1.132/bin64/mpivars.sh intel64
}\n" >> /home/$CLUSTER_USER/.bashrc
