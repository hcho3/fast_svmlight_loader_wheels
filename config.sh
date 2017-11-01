# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function repair_wheelhouse {
  :
}

function pre_build {
  # Any stuff that you need to do before you start building the wheels
  # Runs in the root directory of this repository.
  
  # 1. Build fast_svmlight_loader
  ROOTDIR=$PWD
  if [ -n "$IS_OSX" ]
  then
    # On Mac OS X, install essential build tools
    brew update 1>&2
    brew install autoconf libtool curl gcc@7 1>&2
  fi
  git submodule update --init --recursive   # fetch all submodules
  mkdir -p fast_svmlight_loader/build
  cd fast_svmlight_loader/build
  if [ -n "$IS_OSX" ]
  then
    cmake .. -DCMAKE_CXX_COMPILER=g++-7 -DCMAKE_C_COMPILER=gcc-7 1>&2
  else
    # install CMake 3.1
    if [ "$(uname -m)" == "i686" ]
    then
      wget -nv -nc https://cmake.org/files/v3.1/cmake-3.1.0-Linux-i386.sh --no-check-certificate
      bash cmake-3.1.0-Linux-i386.sh --skip-license --prefix=/usr
    else
      wget -nv -nc https://cmake.org/files/v3.1/cmake-3.1.0-Linux-x86_64.sh --no-check-certificate
      bash cmake-3.1.0-Linux-x86_64.sh --skip-license --prefix=/usr
    fi
    cmake .. 1>&2
  fi
  make -j2 1>&2
  cd $ROOTDIR
}

function run_tests {
  # Runs tests on installed distribution from an empty directory
  python --version
  python -c 'import sys; import fast_svmlight_loader'
}
