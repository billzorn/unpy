import setuptools

with open('README.md', 'rt') as f:
    long_description = f.read()

posit_ext = setuptools.Extension(
    'unpy.posit', ['unpy/posit.c'],
    include_dirs=['unpy/include/'],
    extra_objects=['unpy/lib/libposit_c_api.a'],
    language='c++',
)

setuptools.setup(
    name='unpy',
    version='0.0.1',
    author='Bill Zorn',
    author_email='bill.zorn@gmail.com',
    url='https://github.com/billzorn/unpy',
    description='universal number arithmetic in python',
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=['unpy'],
    ext_modules=[posit_ext],
    package_data={
        'unpy': ['include/*.h', 'lib/*.a'],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: Implementation :: CPython',
        'License :: OSI Approved :: MIT License',
    ],
)
