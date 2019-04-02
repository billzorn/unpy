# unpy

unpy is a Cython wrapper for the c_api offered by universal.

## Installation
On most linux distros with CPython 2.7, 3.4, 3.5, 3.6, or 3.7, unpy should work out of the box:

```
pip install unpy
```

## Building
Some things have been changed in the CMake build files:
```diff
diff --git a/CMakeLists.txt b/CMakeLists.txt
index cbb4254..18f2aa8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -129,7 +129,7 @@ if(CMAKE_COMPILER_IS_GNUCXX OR MINGW OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        # include code quality flags
        set(EXTRA_C_FLAGS "${EXTRA_C_FLAGS} -Wall -Wpedantic -Wno-narrowing -Wno-deprecated")
        # specific flags for debug and release builds
-       set(EXTRA_C_FLAGS_RELEASE "${EXTRA_C_FLAGS_RELEASE} -O3")
+       set(EXTRA_C_FLAGS_RELEASE "${EXTRA_C_FLAGS_RELEASE} -g -O2 -fPIC")
        set(EXTRA_C_FLAGS_DEBUG "${EXTRA_C_FLAGS_DEBUG} -g3 -pthread")
 elseif(MSVC)
        # Streaming SIMD Extension (SSE) ISA
@@ -218,7 +218,7 @@ endif()
 ####
 # set the aggregated compiler options
 set(CMAKE_CXX_FLAGS         "${CMAKE_CXX_FLAGS} ${EXTRA_C_FLAGS}")
-set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${EXTRA_C_FLAGS_RELEASE}")
+set(CMAKE_CXX_FLAGS_RELEASE "${EXTRA_C_FLAGS_RELEASE}")
 set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG} ${EXTRA_C_FLAGS_DEBUG}")
 
 if(PROFILE AND (CMAKE_COMPILER_IS_GNUCXX OR MINGW OR
```
