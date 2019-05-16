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
It will also move the library and headers into the appropriate locations.
```
make libtest
```
will test the library, assuming it is already built.
```
make cython
```
will compile the Cython module to C,
```
make inplace
```
will build the module in place, and
```
make wheel
```
will build a binary wheel distribution in dist/, though this will not be portable
beyond the system used to build it.
```
make sdist
```
will build a source distribution in dist/, though this WILL NOT WORK
unless `make lib` and `make cython` have been run.

To build widely compatible manylinux1 wheels, run `docker-build-wheels.sh` on a suitable image.
Such an image must be based manylinux1, but have a local GCC 8.3.0 compiled and available.
For some background on obtaining such a thing, see
[this issue](https://github.com/pypa/manylinux/issues/118#issuecomment-472380364).
I am working on publishing suitable docker images.

Some helpful commands:
```
docker run -u $(id -u) --rm -v `pwd`:/io -ti billzorn/manylinux1-gcc8:1.2 /io/docker-build-wheels.sh manylinux1_x86_64
make sdist
twine upload --repository-url https://test.pypi.org/legacy/ wheelhouse/* dist/*
pip --no-cache-dir install -i https://testpypi.python.org/pypi unpy
```
Where `billzorn/manylinux1-gcc8.3:1.0` is the local tag of the suitable docker image.
