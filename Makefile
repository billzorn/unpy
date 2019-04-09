all: inplace

clean:
	rm -f unpy/posit.c
	rm -f unpy/posit.cpython*.so
	rm -rf unpy/__pycache__/
	rm -rf unpy.egg-info/
	rm -rf build/
	rm -rf dist/

lib:
	(cd universal && rm -rf build && mkdir build && cd build && cmake -DBUILD_CI_CHECK=ON -DC_API_LIB_PIC=ON .. && make -j8)

libtest:
	(cd universal/build && ctest -j8)

libtestv:
	(cd universal/build && ctest --verbose)

libclean:
	(cd universal && rm -rf build)

cython: $(wildcard unpy/*.pyx) $(wildcard unpy/*.pxd)
	cython unpy/*.pyx

inplace: cython setup.py $(wildcard unpy/*.py) $(wildcard unpy/*.c)
	python setup.py build_ext --inplace

wheel: cython setup.py $(wildcard unpy/*.py) $(wildcard unpy/*.c)
	python setup.py bdist_wheel

.PHONY: clean lib libtest libtestv libclean
