all: inplace

lib:
	(cd universal && rm -rf build && mkdir build && cd build && cmake -DBUILD_CI_CHECK=ON -DC_API_LIB_PIC=ON .. && make -j8)
	mkdir -p unpy/include unpy/lib
	cp universal/posit/posit_c_api.h universal/posit/posit_c_macros.h unpy/include
	cp universal/build/c_api/posit/libposit_c_api.a unpy/lib

libtest:
	(cd universal/build && ctest -j8)

libtestv:
	(cd universal/build && ctest --verbose)

libclean:
	(cd universal && rm -rf build)

cython: $(wildcard unpy/*.pyx) $(wildcard unpy/*.pxd)
	cython unpy/*.pyx

inplace: setup.py $(wildcard unpy/*.py) unpy/posit.c unpy/include/posit_c_api.h unpy/include/posit_c_macros.h unpy/lib/libposit_c_api.a
	python setup.py build_ext --inplace

wheel: setup.py $(wildcard unpy/*.py) unpy/posit.c unpy/include/posit_c_api.h unpy/include/posit_c_macros.h unpy/lib/libposit_c_api.a
	python setup.py bdist_wheel

sdist: setup.py $(wildcard unpy/*.py) unpy/posit.c unpy/include/posit_c_api.h unpy/include/posit_c_macros.h unpy/lib/libposit_c_api.a
	python setup.py sdist

clean:
	rm -f unpy/posit.cpython*.so
	rm -rf unpy/__pycache__/
	rm -rf unpy.egg-info/
	rm -rf build/
	rm -rf dist/

distclean:
	rm -f unpy/posit.c
	rm -rf unpy/include
	rm -rf unpy/lib

allclean: clean distclean libclean

.PHONY: lib libtest libtestv libclean clean distclean
