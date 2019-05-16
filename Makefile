all: inplace

INCLUDE_SOURCES = universal/posit/posit_c_api.h universal/posit/posit_c_macros.h universal/posit/positctypes.h
INCLUDES = unpy/include/posit_c_api.h unpy/include/posit_c_macros.h unpy/include/positctypes.h
LIB_SOURCES = universal/build/c_api/shim/posit/libposit_c_api_shim.a
LIBS = unpy/lib/libposit_c_api_shim.a
CYTHONIZED = unpy/posit.c

lib:
	(cd universal && rm -rf build && mkdir build && cd build && cmake -DBUILD_CI_CHECK=ON -DC_API_LIB_PIC=ON .. && make -j8)
	mkdir -p unpy/include unpy/lib
	cp $(INCLUDE_SOURCES) unpy/include
	cp $(LIB_SOURCES) unpy/lib

libtest:
	(cd universal/build && ctest -j8)

libtestv:
	(cd universal/build && ctest --verbose)

libclean:
	(cd universal && rm -rf build)

cython: $(wildcard unpy/*.pyx) $(wildcard unpy/*.pxd)
	cython unpy/*.pyx

inplace: setup.py $(wildcard unpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py build_ext --inplace

wheel: setup.py $(wildcard unpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py bdist_wheel

sdist: setup.py $(wildcard unpy/*.py) $(CYTHONIZED) $(INCLUDES) $(LIBS)
	python setup.py sdist

clean:
	rm -f unpy/*.cpython*.so
	rm -rf unpy/__pycache__/
	rm -rf unpy.egg-info/
	rm -rf build/
	rm -rf dist/

distclean:
	rm -f $(CYTHONIZED)
	rm -rf unpy/include
	rm -rf unpy/lib

allclean: clean distclean libclean

.PHONY: lib libtest libtestv libclean clean distclean allclean
