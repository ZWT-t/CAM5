#! /bin/sh
###set mpi and netcdf###
mpich=/opt/CAM5.3/mpich/3.3.2
export INC_MPI=${mpich}/include
export LIB_MPI=${mpich}/lib
echo "INC_MPI:  " $INC_MPI
echo "LIB_MPI:  " $LIB_MPI

NETCDF=/opt/CAM5.3/netcdf/intel/4.1.3
export INC_NETCDF=${NETCDF}/include
export LIB_NETCDF=${NETCDF}/lib
echo "INC_NETCDF:  " $INC_NETCDF
echo "LIB_NETCDF:  " $LIB_NETCDF

export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#export CC=icc
#export CXX=icpc
#export FC=ifort
#export F77=ifort
#export F90=ifort
#export MPIFC=mpif90
#export MPICC=mpicc

## ROOT OF CAM DISTRIBUTION - probably needs to be customized.
## Contains the source code for the CAM distribution.
## (the root directory contains the subdirectory "models")
##@@@@@@@@@@@@@@@@@
camversion=cam5_3_17
camroot=/ME4DATA/Zhangwt/CAM5.3/ModelCode/$camversion
curdir=`pwd`
##@@@@@@@@@@@@@@@@@
case=test_intel_none_newenv
#set modf   = test
#set usrsrc = $curdir/Modify_mods/'mods_'$modf
#echo "modified files in the directoy:" $usrsrc
## Default namelist settings:
## $case is the case identifier for this run.

## ROOT OF CAM DATA DISTRIBUTION - needs to be customized unless running at NCAR.
## Contains the initial and boundary data for the CAM distribution.
## (the root directory contains the subdirectories "atm" and "lnd")
export CSMDATA=/ME4DATA/public/CESM_input/Inputdata

## $wrkdir is a working directory where the model will be built and run.
## $blddir is the directory where model will be compiled.
## $rundir is the directory where the namelist(*_in) will be make.
## $cfgdir is the directory containing the CAM configuration scripts.
#set wrkdir       = /nuist/scratch/shixj/$LOGNAME/$camversion/$case'1x1'
wrkdir=/ME4DATA/Zhangwt/CAM5.3/Outfld/$case
blddir=$wrkdir/bld
rundir=$wrkdir/
cfgdir=$camroot/models/atm/cam/bld

rm -fr  $blddir
rm -fr  $wrkdir
rm -fr  $rundir

## Ensureq that run and build directories exist

mkdir -p $rundir                || ( echo "cannot create $rundir"  &&  exit 1 )
mkdir -p $blddir                || ( echo "cannot create $blddir"  &&  exit 1 )
echo $usrsrc
## If an executable doesn't exist, build one.
  ## build execut
  cd $blddir                  || ( echo "cd $blddir failed" && exit 1 )
  echo "building CAM in $blddir ..."
  echo "Compilation starts on "`date`
  echo  $cfgdir

  $cfgdir/configure \
      -cc mpicc -fc mpif90 -fc_type gnu \
      -phys cam5 \
      -chem none \
      -test \
      -spmd \
      -nosmp \
      -dyn fv \
      -res 1.9x2.5 -cice_bsizex 3 -cice_bsizey 96 -cice_maxblocks 24 -cice_decomptype cartesian \
      || ( echo "configure failed" && exit 1 )
#  rm -f Depends
   /usr/bin/gmake -j8 >& MAKE.out      || ( echo "CAM build failed: see $blddir/MAKE.out" && exit 1 )
#  rm -f *.o *.mod

  echo "Compilation stops  on "`date`



echo " "
echo "Create the namelist..."
echo " "
cd $rundir                      || ( echo "cd $rundir failed" && exit 1 )
$cfgdir/build-namelist -verbose -case $case -runtype 'startup' -d $rundir  \
  -config $blddir/config_cache.xml \
  -namelist "&camexp  stop_n=24, stop_option='nmonths' \
   npr_yz = 1,1,1,1 \
 / "  || echo "build-namelist failed" && exit 1
echo " "
echo "build-namelist complete"
echo " "

cp $blddir/cam $wrkdir

# exit 0
