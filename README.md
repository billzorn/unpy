# unpy

unpy is a Cython wrapper for the c_api offered by [universal](https://github.com/stillwater-sc/universal).

## Installation
On most linux distros with CPython 2.7, 3.4, 3.5, 3.6, or 3.7, unpy should work out of the box:

```
pip install -i https://testpypi.python.org/pypi unpy
```

Right now, it has only been shipped to Test PyPI, so availability may be dependent on
the last time the Test PyPI repository was wiped, and the package should in general
be considered unstable.

## Building
Astonishingly, universal has build options which allow its c_api library to work
with Cython out of the box. The process has been captured in the provided Makefile.

```
make lib
```
will build the universal library, assuming the submodule is checked out and in good shape.
```
make libtest
```
will test the library, assuming it is already built.
```
make inplace
```
will build the module in place, while
```
make wheel
```
will build a binary wheel distribution in dist/, though this will not be portable
beyond the system used to build it.

To build widely compatible manylinux1 wheels, run `docker-build-wheels.sh` on a suitable image.
Such an image must be based manylinux1, but have a local GCC 8.3.0 compiled and available
in `/usr/local/gcc-8.3.0/bin/`. For some background on obtaining such a thing, see
[this issue](https://github.com/pypa/manylinux/issues/118#issuecomment-472380364).

Some helpful commands:
```
sudo docker run -u $(id -u) --rm -v `pwd`:/io -ti billzorn/manylinux1-gcc8.3:1.0 /io/docker-build-wheels.sh
```
Where `billzorn/manylinux1-gcc8.3:1.0` is the local tag of the suitable docker image.
