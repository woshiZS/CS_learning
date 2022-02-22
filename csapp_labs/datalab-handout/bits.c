/* 
 * CS:APP Data Lab 
 * 
 * <Please put your name and userid here>
 * Jason Heywood
 * Self learners
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting if the shift amount
     is less than 0 or greater than 31.


EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implement floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants. You can use any arithmetic,
logical, or comparison operations on int or unsigned data.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operations (integer, logical,
     or comparison) that you are allowed to use for your implementation
     of the function.  The max operator count is checked by dlc.
     Note that assignment ('=') is not counted; you may use as many of
     these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
//1
/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
  int rev_x = ~x;
  int rev_y = ~y;
  return ~((~(x & rev_y)) & (~(rev_x & y)));
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
  return 1 << 31;
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
  // if yes return 1 otherwise return 0
  int rev = ~x, next = x + 1;
  // judge if x == tmax
  // how to judge if two number equals, xor operation
  int result = rev ^ next; // result will be zero if it qualifies
  // if I reverse using !, it wiil 1, otherwise it will zero
  result = !result;
  return result & !!(~x);
}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
  // 32 bit , all old bit has 16 ones, one per time will exceed max ops, but we can find that
  // each four bit has the same pattern, 1010, so we only need to check for 8 times, but the max we can use is 0xFF
  // the max pattern qualified is 0xAA, this way we only need to verify 4 times.
  int pattern = 0xAA, ret;
  pattern = (pattern << 8) | pattern;
  pattern = (pattern << 16) | pattern;
  // if x all old bit but other bit is set, it should also return 1, so we can not directly do xor operaiton,
  // before xor opertion we need a and operation to get rid of influence of bits.
  x &= pattern;
  ret =  x ^ pattern;
  return !ret;  
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
  // 2's complement 
  // right shift in C is arithmetic operation.
  // reverse and then add 1
  x = ~x;
  x += 1;
  return x;
}
//3
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
  // range judgement, real subtraction is 2's complement addition
  // normal process is do arithmetic 
  int rev_x = ~x + 1;
  int rev_low_bound = ~(0x30) + 1;
  int ret = x + rev_low_bound;
  // first bit is zero
  int ret_2 = 0x39 + rev_x;
  ret = (1 << 31) & (ret | ret_2);
  return !ret;
}
/* 
 * conditional - same as x ? y : z 
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
  // x is true when it is not zero, how to select number without if condition
  // if x is 1, return y otherwise return z, ret = y & (x << )
  int rev_x = !x, ret;
  x = !rev_x;
  // how to construct all 1 with only one lsb? left shift 32 bit and right shift 32 bit.
  ret = (y & ((x << 31) >> 31)) + (z & ((rev_x << 31) >> 31));
  return ret;
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
  // consider overflow conditions, x too small, y too large
  // like x = 0x80000000, y = 0x7fffffff,y - x will be negative
  // other condition like x is to large y is too small, e.g:
  // x = 0x7fffffff, y = 0x80000000, y - x will positive.
  int sign_x = (x >> 31) & 1, sign_y = (y >> 31) & 1, c1, c2;
  c1 = sign_x & ~sign_y; // represent first condition
  c2 = ~sign_x & sign_y; // represent the second condition.
  y += ~x + 1;
  // check sign bit, if sign bit is 0, return 1, otherwise return 0
  y = y & (1 << 31);
  return c1 | (!y & !c2);
}
//4
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {
  // any number except zero will have at least 1 at the sign bit
  int rev_x = ~x + 1;
  x = x | rev_x;
  x = x & (1 << 31);
  x = x >> 31;
  x = ~x & 1;
  return x;
}
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
  // highest bit 
  int sign = x >> 31, u16, u8, u4, u2, u1;
  // tranverse all the numbers to positive numbers, and needed bit will not change.
  x = (sign & ~x) | (~sign & x);
  // check if the higher 16 bits contains 1, if it is, it will be 1, otherwise will be 0.
  u16 = !!(x >> 16) << 4;
  // if upper 16 bit has 1, we can jsut move 16 bit to the right and test the upper 8 bit
  x = x >> u16;
  u8 = !!(x >> 8) << 3;
  x = x >> u8;
  u4 = !!(x >> 4) << 2;
  x = x >> u4;
  u2 = !!(x >> 2) << 1;
  x = x >> u2;
  u1 = !!(x >> 1);
  x = x >> u1;
  return 1 + u16 + u8 + u4 + u2 + u1 + x;
}
//float
/* 
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatScale2(unsigned uf) {
  // it depends 
  // normal condition, just add 1 to exp part
  // denormalized conditions
  // special cases: NaN or infinity
  unsigned sign = (uf & 0x80000000u);
  unsigned exp = (uf & 0x7F800000u);
  unsigned fraction = (uf & 0x007FFFFFu);
  if((exp ^ 0x7F800000u) == 0)
    return uf;
  if(!exp)
    return (uf << 1) | sign;
  exp += 0x00800000u;
  return sign | exp | fraction;
}
/* 
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int floatFloat2Int(unsigned uf) {
  unsigned sign = (uf & 0x80000000u);
  unsigned exp = (uf & 0x7F800000u) >> 23;
  unsigned fraction = (uf & 0x007FFFFFu) | 0x00800000u;
  int ret;
  if((exp ^ 0x7F800000u) == 0)
    return 0x80000000u;
  // denormalized conditions
  if(!exp)
    return 0;
  // normalized conditions
  if(exp < 127)
    return 0;
  // too big will cause overflow, 1.xxx will most move 30 bit, otherwise it will be overflow,
  // negative number should return 0x80000000u, also negative max value.
  if(exp > 157)
    return 0x80000000u;
  if(exp >= 150)
    ret = fraction << (exp - 150);
  else
    ret = fraction >> (150 - exp);

  if(sign)
    ret = ~ret + 1;
  return ret;
}
/* 
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 * 
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while 
 *   Max ops: 30 
 *   Rating: 4
 */
unsigned floatPower2(int x) {
    // judge the range of int x, max exp is 127, the min value is -149
    if(x > 127)
      return 0x7F800000u;
    if(x < -149)
      return 0;
    if(x >= -126)
      return (x + 127) << 23;
    return 1u << (149 + x);
}
