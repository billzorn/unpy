# cython: language_level=3

from libc.stdint cimport *
from . cimport cposit

# special values and c helpers
#cdef _p32_one = cposit.ui32_to_p32(1)

cdef inline cposit.posit32_t _p32_neg(cposit.posit32_t f):
    f.v = -f.v
    return f

cdef inline cposit.posit32_t _p32_abs(cposit.posit32_t f):
    f.v = <uint32_t> abs(<int32_t> f.v)
    return f
# these tricks won't work well with larger posit types...


cdef demo_foobarbaz():
    cdef cposit.posit32_t x = cposit.posit32_fromsi(1)
    cdef cposit.posit32_t y = cposit.posit32_fromsi(-3)

    cdef int xd = cposit.posit32_tosi(x)
    cdef int yd = cposit.posit32_tosi(y)

    cdef cposit.posit32_t x_y = cposit.posit32_add(x, y)
    cdef int x_yd = cposit.posit32_tosi(x_y)

    print(xd, yd, x_yd)
    print(cposit.posit32_cmp(x, y))
    print(cposit.posit32_cmp(x, x))
    print(cposit.posit32_cmp(x, x_y))

    return 0

demo_foobarbaz()

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

    # cpdef bint eq(self, Posit32 other):
    #     return cposit.p32_eq(self._c_posit, other._c_posit)

    # cpdef bint le(self, Posit32 other):
    #     return cposit.p32_le(self._c_posit, other._c_posit)

    # cpdef bint lt(self, Posit32 other):
    #     return cposit.p32_lt(self._c_posit, other._c_posit)

    # def __lt__(self, Posit32 other):
    #     return self.lt(other)

    # def __le__(self, Posit32 other):
    #     return self.le(other)

    # def __eq__(self, Posit32 other):
    #     return self.eq(other)

    # def __ne__(self, Posit32 other):
    #     return not self.eq(other)

    # def __ge__(self, Posit32 other):
    #     return other.le(self)

    # def __gt__(self, Posit32 other):
    #     return other.lt(self)

    # conversion to other posit types
