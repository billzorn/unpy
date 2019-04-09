#!/bin/bash
set -e -x
cd /io/

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake

export CFLAGS="-static-libstdc++"
export CXXFLAGS="-static-libstdc++"
export CC=/usr/local/gcc-8.3.0/bin/gcc-8.3.0
export CXX=/usr/local/gcc-8.3.0/bin/g++-8.3.0

make lib

export LD_LIBRARY_PATH=/usr/local/gcc-8.3.0/lib64/

make libtestv

# cleanup
deactivate
rm -rf .cmake
make libclean
