// compile and run me with:
// g++ -g -O0 breaking.c universal/build/c_api/posit/libposit_c_api.a && ./a.out

#include <stdio.h>
#include "universal/posit/posit_c_api.h"

int main() {
    double xd = 1.3;
    posit32_t x;

    printf("%f\n", xd);
    
    x = posit32_fromd(xd);
    printf("x = %d, %f\n", x.v, posit32_tod(x));
    
    printf("Done.\n");
    return 0;
}



/*
CMake building c_api_posit32

cd /home/bill/private/tools/universal/build/c_api/test/posit &&
/usr/bin/cc  -I/home/bill/private/tools/universal/./posit  -O3 -DNDEBUG   -o CMakeFiles/c_api_posit32.dir/posit32.c.o   -c /home/bill/private/tools/universal/c_api/test/posit/posit32.c

/usr/bin/c++    -Wall -Wpedantic -Wno-narrowing -Wno-deprecated -std=c++14  -g -O2   CMakeFiles/c_api_posit32.dir/posit32.c.o  -o c_api_posit32 ../../posit/libosit_c_api.a
 */




/*
CMake building posit c lib

[ 90%] Building CXX object c_api/posit/CMakeFiles/posit_c_api.dir/posit_c_api.cpp.o
cd /home/bill/private/tools/universal/build/c_api/posit && /usr/bin/c++   -I/home/bill/private/tools/universal/./posit  -Wall -Wpedantic -Wno-narrowing -Wno-deprecated -std=c++14  -g -O2   -std=gnu++14 -o CMakeFiles/posit_c_api.dir/posit_c_api.cpp.o -c /home/bill/private/tools/universal/c_api/posit/posit_c_api.cpp
In file included from /home/bill/private/tools/universal/./posit/specializations.hpp:32:0,
                 from /home/bill/private/tools/universal/./posit/posit:48,
                 from /home/bill/private/tools/universal/c_api/posit/posit_c_api.cpp:16:
/home/bill/private/tools/universal/./posit/specialized/posit_4_0.hpp:12:52: note: #pragma message: Fast specialization of posit<4,0>
 #pragma message("Fast specialization of posit<4,0>")
                                                    ^
In file included from /home/bill/private/tools/universal/./posit/specializations.hpp:33:0,
                 from /home/bill/private/tools/universal/./posit/posit:48,
                 from /home/bill/private/tools/universal/c_api/posit/posit_c_api.cpp:16:
/home/bill/private/tools/universal/./posit/specialized/posit_8_0.hpp:13:52: note: #pragma message: Fast specialization of posit<8,0>
 #pragma message("Fast specialization of posit<8,0>")
                                                    ^
In file included from /home/bill/private/tools/universal/./posit/specializations.hpp:34:0,
                 from /home/bill/private/tools/universal/./posit/posit:48,
                 from /home/bill/private/tools/universal/c_api/posit/posit_c_api.cpp:16:
/home/bill/private/tools/universal/./posit/specialized/posit_16_1.hpp:13:53: note: #pragma message: Fast specialization of posit<16,1>
 #pragma message("Fast specialization of posit<16,1>")
                                                     ^
In file included from /home/bill/private/tools/universal/./posit/specializations.hpp:35:0,
                 from /home/bill/private/tools/universal/./posit/posit:48,
                 from /home/bill/private/tools/universal/c_api/posit/posit_c_api.cpp:16:
/home/bill/private/tools/universal/./posit/specialized/posit_32_2.hpp:13:53: note: #pragma message: Fast specialization of posit<32,2>
 #pragma message("Fast specialization of posit<32,2>")
                                                     ^
[ 91%] Linking CXX static library libposit_c_api.a
cd /home/bill/private/tools/universal/build/c_api/posit && /usr/bin/cmake -P CMakeFiles/posit_c_api.dir/cmake_clean_target.cmake
cd /home/bill/private/tools/universal/build/c_api/posit && /usr/bin/cmake -E cmake_link_script CMakeFiles/posit_c_api.dir/link.txt --verbose=1
/usr/bin/ar qc libposit_c_api.a  CMakeFiles/posit_c_api.dir/posit_c_api.cpp.o
/usr/bin/ranlib libposit_c_api.a
make[2]: Leaving directory '/home/bill/private/tools/universal/build'
[ 91%] Built target posit_c_api
 */
