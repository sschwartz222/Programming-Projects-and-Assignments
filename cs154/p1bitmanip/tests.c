/* Testing Code */

#include <limits.h>
#include <math.h>

int test_absVal(int x) {
  return (x < 0) ? -x : x;
}

int test_allOddBits(int x) {
  int i;
  for (i = 1; i < 32; i+=2)
      if ((x & (1<<i)) == 0)
   return 0;
  return 1;
}

int test_bang(int x)
{
  return !x;
}

int test_bitMask(int highbit, int lowbit)
{
  int result = 0;
  int i;
  for (i = lowbit; i <= highbit; i++)
    result |= 1 << i;
  return result;
}

int test_bitNor(int x, int y)
{
  return ~(x|y);
}

int test_byteSwap(int x, int n, int m)
{
    /* little endiamachine */
    /* least significant byte stored first */

    unsigned int nmask, mmask;

    switch(n) {
    case 0:
      nmask = x & 0xFF;
      x &= 0xFFFFFF00;
      break;
    case 1:
      nmask = (x & 0xFF00) >> 8;
      x &= 0xFFFF00FF;
      break;
    case 2:
      nmask = (x & 0xFF0000) >> 16;
      x &= 0xFF00FFFF;
      break;
    default:
      nmask = ((unsigned int)(x & 0xFF000000)) >> 24;
      x &= 0x00FFFFFF;
      break;
    }

    switch(m) {
    case 0:
      mmask = x & 0xFF;
      x &= 0xFFFFFF00;
      break;
    case 1:
      mmask = (x & 0xFF00) >> 8;
      x &= 0xFFFF00FF;
      break;
    case 2:
      mmask = (x & 0xFF0000) >> 16;
      x &= 0xFF00FFFF;
      break;
    default:
      mmask = ((unsigned int)(x & 0xFF000000)) >> 24;
      x &= 0x00FFFFFF;
      break;
    }

    nmask <<= 8*m;
    mmask <<= 8*n;

    return x | nmask | mmask;
}

int test_conditional(int x, int y, int z)
{
  return x?y:z;
}

int test_evenBits(void) {
  int result = 0;
  int i;
  for (i = 0; i < 32; i+=2)
    result |= 1<<i;
  return result;
}

int test_ezThreeFourths(int x)
{
  return (x*3)/4;
}

int test_fitsShort(int x)
{
  short int sx = (short int) x;
  return x == sx;
}

int test_getByte(int x, int n)
{
    unsigned char byte;
    switch(n) {
    case 0:
      byte = x;
      break;
    case 1:
      byte = x >> 8;
      break;
    case 2:
      byte = x >> 16;
      break;
    default:
      byte = x >> 24;
      break;
    }
    return (int) (unsigned) byte;
}

int test_howManyBits(int x) {
    unsigned int a, cnt;
    x = x<0 ? -x-1 : x;
    a = (unsigned int)x;
    for (cnt=0; a; a>>=1, cnt++)
        ;
    return (int)(cnt + 1);
}

int test_implication(int x, int y)
{
  return !(x & (!y));
}

int test_isAsciiDigit(int x) {
  return (0x30 <= x) && (x <= 0x39);
}

int test_isGreater(int x, int y)
{
  return x > y;
}

int test_isNonNegative(int x) {
  return x >= 0;
}

int test_isTmax(int x) {
    return x == 0x7FFFFFFF;
}

int test_minusOne(void) {
  return -1;
}

int test_rotateRight(int x, int n) {
  unsigned u = (unsigned) x;
  int i;
  for (i = 0; i < n; i++) {
      unsigned lsb = (u & 1) << 31;
      unsigned rest = u >> 1;
      u = lsb | rest;
  }
  return (int) u;
}

int test_satAdd(int x, int y)
{
  if (x > 0 && y > 0 && x+y < 0)
    return (0x7FFFFFFF);
  if (x < 0 && y < 0 && x+y >= 0)
    return (0x80000000);
  return x + y;
}

int test_sign(int x) {
    if ( !x ) return 0;
    return (x < 0) ? -1 : 1;
}

int test_subOK(int x, int y)
{
  long long ldiff = (long long) x - y;
  return ldiff == (int) ldiff;
}

