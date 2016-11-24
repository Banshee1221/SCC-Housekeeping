wget https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.gz
tar zxvf openmpi-2.0.1.tar.gz
cd openmpi-2.0.1/
./configure --prefix=/usr/local
make all
sudo make install
sudo ldconfig
