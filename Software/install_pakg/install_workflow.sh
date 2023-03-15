#!/bin/bash

echo CAM5.3_Software_Install_use_gfortran
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export Dir=/opt/CAM5.3

### tar packages directory
export Tar=$Dir/install_pakg/tar
### untar directory
export UNTar=$Dir/install_pakg/untar


# ##zlib
 #tar -zxvf ${Tar}/zlib-1.2.11.tar.gz  -C  ${UNTar}/
 #cd  ${UNTar}/zlib-1.2.11/
 #./configure --prefix=$Dir/zlib/1.2.11
 #make
 #make install

# ##libpng
 #tar -zxvf ${Tar}/libpng-1.6.37.tar.gz  -C  ${UNTar}/
 #cd  ${UNTar}/libpng-1.6.37/
 #./configure --prefix=$Dir/libpng/1.6.37
 #make
 #make install

# ##libpng
 #tar -zxvf ${Tar}/jasper-1.900.1.tar.gz  -C  ${UNTar}/
 #cd  ${UNTar}/jasper-1.900.1/
 #./configure --prefix=$Dir/jasper/1.900.1
 #make
 #make install

# # #####hdf5
# tar -zxvf ${Tar}/hdf5-1.8.20.tar.gz -C  ${UNTar}/
# cd  ${UNTar}/hdf5-1.8.20/
# ./configure --enable-fortran --enable-cxx --prefix=$Dir/hdf5/1.8.20
# make -j16
# make install

### netcdf
# tar -xvf ${Tar}/netcdf-4.1.3.tar.gz -C ${UNTar}/
# cd  ${UNTar}/netcdf-4.1.3/
# ./configure --prefix=$Dir/netcdf/intel/4.1.3 --enable-netcdf4  # --disable-dap --enable-netcdf4  --disable-shared
# make -j16
# make install

###mpich
tar -zxvf ${Tar}/mpich-3.3.2.tar.gz -C  ${UNTar}/
cd  ${UNTar}/mpich-3.3.2/
./configure --prefix=$Dir/mpich/3.3.2
make -j16
make install
