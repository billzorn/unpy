#!/bin/bash
set -e -x
cd /io/

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake

export CFLAGS="-static-libstdc++"
export CXXFLAGS="-static-libstdc++"
export CC="${GCC_PATH}/bin/gcc"
export CXX="${GCC_PATH}/bin/g++"
# export PATH="${GCC_PATH}/bin:${PATH}"

which gcc

make lib

export LD_LIBRARY_PATH="${GCC_PATH}/lib64"

make libtestv

# cleanup
deactivate
rm -rf .cmake
make libclean
