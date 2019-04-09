#!/bin/bash
set -e -x
cd /io/

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake

export CFLAGS="-static-libstdc++"
export CC=/usr/local/gcc-8.3.0/bin/gcc-8.3.0
export CXX=/usr/local/gcc-8.3.0/bin/g++-8.3.0

(cd universal && rm -rf build && mkdir build && cd build && cmake -DBUILD_CI_CHECK=ON -DC_API_LIB_PIC=ON .. && make -j8)

(cd universal/build && LD_LIBRARY_PATH=/usr/local/gcc-8.3.0/lib64/ ctest --verbose)

# cleanup
deactivate
rm -rf .cmake
rm -rf universal/build
