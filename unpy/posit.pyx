# cython: language_level=3

from libc.stdint cimport *
from . cimport cposit


# special values and c helpers

cdef inline cposit.posit32_t _p32_neg(cposit.posit32_t f):
    f.v = -f.v
    return f

cdef inline cposit.posit32_t _p32_abs(cposit.posit32_t f):
    f.v = <uint32_t> abs(<int32_t> f.v)
    return f

# these tricks won't work well with larger posit types...


cdef class Posit32:

    # the wrapped posit value
    cdef cposit.posit32_t _c_posit

    # factory function constructors that bypass __init__

    @staticmethod
    cdef Posit32 from_c_posit(cposit.posit32_t f):
        """Factory function to create a Posit32 object directly from
        a C posit32_t.
        """
        cdef Posit32 obj = Posit32.__new__(Posit32)
        obj._c_posit = f
        return obj

    @staticmethod
    def from_bits(uint32_t value):
        """Factory function to create a Posit32 object from a bit pattern
        represented as an integer.
        """
        cdef Posit32 obj = Posit32.__new__(Posit32)
        obj._c_posit.v = value
        return obj

    @staticmethod
    def from_double(double value):
        """Factory function to create a Posit32 object from a double.
        """
        cdef Posit32 obj = Posit32.__new__(Posit32)
        obj._c_posit = cposit.posit32_fromd(value)
        return obj

    @staticmethod
    def from_signed(long long value):
        """Factory function to create a Posit32 object from a double.
        """
        cdef Posit32 obj = Posit32.__new__(Posit32)
        obj._c_posit = cposit.posit32_fromsll(value)
        return obj

    @staticmethod
    def from_unsigned(unsigned long long value):
        """Factory function to create a Posit32 object from a double.
        """
        cdef Posit32 obj = Posit32.__new__(Posit32)
        obj._c_posit = cposit.posit32_fromull(value)
        return obj

    # convenience interface for use inside Python

    def __init__(self, value):
        """Turn value into a (python) float, then convert that into
        a posit32. This may double-round, producing an incorrect
        value for things that are not already python floats.
        """
        self._c_posit = cposit.posit32_fromd(float(value))

    def __float__(self):
        return cposit.posit32_tod(self._c_posit)

    def __int__(self):
        return int(cposit.posit32_tod(self._c_posit))

    def __str__(self):
        return repr(cposit.posit32_tod(self._c_posit))

    def __repr__(self):
        return 'Posit32(' + repr(cposit.posit32_tod(self._c_posit)) + ')'

    cpdef uint32_t get_bits(self):
        return self._c_posit.v
    bits = property(get_bits)

    # arithmetic

    cpdef Posit32 neg(self):
        cdef cposit.posit32_t f = _p32_neg(self._c_posit)
        return Posit32.from_c_posit(f)

    def __neg__(self):
        return self.neg()

    cpdef Posit32 abs(self):
        cdef cposit.posit32_t f = _p32_abs(self._c_posit)
        return Posit32.from_c_posit(f)

    def __abs__(self):
        return self.abs()

    # cpdef Posit32 round(self):
    #     cdef cposit.posit32_t f = cposit.p32_roundToInt(self._c_posit)
    #     return Posit32.from_c_posit(f)

    # def __round__(self):
    #     return self.round()

    cpdef Posit32 add(self, Posit32 other):
        cdef cposit.posit32_t f = cposit.posit32_add(self._c_posit, other._c_posit)
        return Posit32.from_c_posit(f)

    def __add__(self, Posit32 other):
        return self.add(other)

    cpdef Posit32 sub(self, Posit32 other):
        cdef cposit.posit32_t f = cposit.posit32_sub(self._c_posit, other._c_posit)
        return Posit32.from_c_posit(f)

    def __sub__(self, Posit32 other):
        return self.sub(other)

    cpdef Posit32 mul(self, Posit32 other):
        cdef cposit.posit32_t f = cposit.posit32_mul(self._c_posit, other._c_posit)
        return Posit32.from_c_posit(f)

    def __mul__(self, Posit32 other):
        return self.mul(other)

    # cpdef Posit32 fma(self, Posit32 a1, Posit32 a2):
    #     cdef cposit.posit32_t f = cposit.p32_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)
    #     return Posit32.from_c_posit(f)

    cpdef Posit32 div(self, Posit32 other):
        cdef cposit.posit32_t f = cposit.posit32_div(self._c_posit, other._c_posit)
        return Posit32.from_c_posit(f)

    def __truediv__(self, Posit32 other):
        return self.div(other)

    cpdef Posit32 sqrt(self):
        cdef cposit.posit32_t f = cposit.posit32_sqrt(self._c_posit)
        return Posit32.from_c_posit(f)

    cpdef int cmp(self, Posit32 other):
        return cposit.posit32_cmp(self._c_posit, other._c_posit)

    # in-place arithmetic

    cpdef void ineg(self):
        self._c_posit = _p32_neg(self._c_posit)

    cpdef void iabs(self):
        self._c_posit = _p32_abs(self._c_posit)

    # cpdef void iround(self):
    #     self._c_posit = cposit.p32_roundToInt(self._c_posit)

    cpdef void iadd(self, Posit32 other):
        self._c_posit = cposit.posit32_add(self._c_posit, other._c_posit)

    def __iadd__(self, Posit32 other):
        self.iadd(other)
        return self

    cpdef void isub(self, Posit32 other):
        self._c_posit = cposit.posit32_sub(self._c_posit, other._c_posit)

    def __isub__(self, Posit32 other):
        self.isub(other)
        return self

    cpdef void imul(self, Posit32 other):
        self._c_posit = cposit.posit32_mul(self._c_posit, other._c_posit)

    def __imul__(self, Posit32 other):
        self.imul(other)
        return self

    # cpdef void ifma(self, Posit32 a1, Posit32 a2):
    #     self._c_posit = cposit.p32_mulAdd(a1._c_posit, a2._c_posit, self._c_posit)

    cpdef void idiv(self, Posit32 other):
        self._c_posit = cposit.posit32_div(self._c_posit, other._c_posit)

    def __itruediv__(self, Posit32 other):
        self.idiv(other)
        return self

    cpdef void isqrt(self):
        self._c_posit = cposit.posit32_sqrt(self._c_posit)

    # comparison

    def __lt__(self, Posit32 other):
        return self.cmp(other) < 0

    def __le__(self, Posit32 other):
        return self.cmp(other) <= 0

    def __eq__(self, Posit32 other):
        return self.cmp(other) == 0

    def __ne__(self, Posit32 other):
        return not (self.cmp(other) == 0)

    def __ge__(self, Posit32 other):
        return self.cmp(other) >= 0

    def __gt__(self, Posit32 other):
        return self.cmp(other) > 0


# wrap functions from the c API headers

cpdef Posit32 posit32_fromd(double value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromd(value)
    return obj

# these will not normally be usable from within Python,
# as it can't natively pass a float or lond double argument
cpdef Posit32 posit32_fromf(float value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromf(value)
    return obj

cpdef Posit32 posit32_fromld(long double value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromld(value)
    return obj

# these integer conversions should all have the same behavior
# besides shorter types rejecting Python integers over a
# certain size
cpdef Posit32 posit32_fromsi(int value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsi(value)
    return obj

cpdef Posit32 posit32_fromsl(long value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsl(value)
    return obj

cpdef Posit32 posit32_fromsll(long long value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsll(value)
    return obj

cpdef Posit32 posit32_fromui(unsigned int value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsi(value)
    return obj

cpdef Posit32 posit32_fromul(unsigned long value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsl(value)
    return obj

cpdef Posit32 posit32_fromull(unsigned long long value):
    cdef Posit32 obj = Posit32.__new__(Posit32)
    obj._c_posit = cposit.posit32_fromsll(value)
    return obj

# turn posits into other things...
cpdef double posit32_tod(Posit32 a):
    return cposit.posit32_tod(a._c_posit)

cpdef float posit32_tof(Posit32 a):
    return cposit.posit32_tof(a._c_posit)

cpdef long double posit32_told(Posit32 a):
    return cposit.posit32_told(a._c_posit)

cpdef int posit32_tosi(Posit32 a):
    return cposit.posit32_tosi(a._c_posit)

cpdef long posit32_tosl(Posit32 a):
    return cposit.posit32_tosl(a._c_posit)

cpdef long long posit32_tosll(Posit32 a):
    return cposit.posit32_tosll(a._c_posit)

cpdef unsigned int posit32_toui(Posit32 a):
    return cposit.posit32_toui(a._c_posit)

cpdef unsigned long posit32_toul(Posit32 a):
    return cposit.posit32_toul(a._c_posit)

cpdef unsigned long long posit32_toull(Posit32 a):
    return cposit.posit32_toull(a._c_posit)

# strings are a little different
cpdef str posit32_str(Posit32 a):
    cdef char buf[cposit.posit32_str_SIZE]
    cposit.posit32_str(buf, a._c_posit)
    cdef bytes s = buf
    return s.decode('ascii')
