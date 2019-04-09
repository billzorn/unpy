#!/bin/bash
set -e -x
cd /io/

# build the universal posit library

rm -rf .cmake
/opt/python/cp37-cp37m/bin/python -m venv .cmake
source .cmake/bin/activate

pip install cmake

export CFLAGS="-static-libstdc++"
export CXXFLAGS="-static-libstdc++"
export CC=/usr/local/gcc-8.3.0/bin/gcc-8.3.0
export CXX=/usr/local/gcc-8.3.0/bin/g++-8.3.0

(cd universal && rm -rf build && mkdir build && cd build && cmake -DBUILD_CI_CHECK=ON -DC_API_LIB_PIC=ON .. && make -j8)

deactivate

# build the wheels

rm -f wheelhouse/*.whl

for PYBIN in /opt/python/*/bin; do
    "${PYBIN}/pip" wheel . -w wheelhouse/
done

for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w wheelhouse/
done

rm wheelhouse/*linux_x86_64.whl

# cleanup
rm -rf .cmake
rm -rf universal/build
