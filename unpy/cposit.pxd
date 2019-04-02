from libc.stdint cimport *

cdef extern from '../universal/posit/posit_c_api.h':

    # some important quantities
    enum:
        posit32_str_SIZE

    # Transparent types so we can have access to the raw bits.

    ctypedef struct posit32_t:
        uint8_t x[4];
        uint32_t v;

    # /*----------------------------------------------------------------------------
    # | Converstion to posits.
    # *----------------------------------------------------------------------------*/

    posit32_t posit32_fromd( double );
    posit32_t posit32_fromf( float );
    posit32_t posit32_fromld( long double );
    posit32_t posit32_fromsi( int );
    posit32_t posit32_fromsl( long );
    posit32_t posit32_fromsll( long long );
    posit32_t posit32_fromui( unsigned int );
    posit32_t posit32_fromul( unsigned long );
    posit32_t posit32_fromull( unsigned long long );

    # /*----------------------------------------------------------------------------
    # | Converstion from posits.
    # *----------------------------------------------------------------------------*/

    double posit32_tod( posit32_t );
    float posit32_tof( posit32_t );
    long double posit32_told( posit32_t );
    int posit32_tosi( posit32_t );
    long posit32_tosl( posit32_t );
    long long posit32_tosll( posit32_t );
    unsigned int posit32_toui( posit32_t );
    unsigned long posit32_toul( posit32_t );
    unsigned long long posit32_toull( posit32_t );

    posit32_str(char *, posit32_t);

    # /*----------------------------------------------------------------------------
    # | Math functions.
    # *----------------------------------------------------------------------------*/

    posit32_t posit32_add( posit32_t, posit32_t );
    posit32_t posit32_sub( posit32_t, posit32_t );
    posit32_t posit32_mul( posit32_t, posit32_t );
    posit32_t posit32_div( posit32_t, posit32_t );

    int32_t posit32_cmp( posit32_t, posit32_t );

    posit32_t posit32_sqrt( posit32_t );
