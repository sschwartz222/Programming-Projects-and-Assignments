#ifndef FUNCTIONS_H
#define FUNCTIONS_H

/* print_stuff: prints several variables of different types
 * purpose is to illustrate printf and the types C provides 
 * void means it doesn't return a value - it does something instead
 * inputs:
 *    int ival - integer value that will be printed out as an integer
 *    float fval - floating-point value that will be printed out as a float
 *    double dval - more precise fp value that will be printed as a long float
 *    char cval - char value that will be printed out as a character
 */
void print_stuff(int ival, float fval, double dval, char cval);

/* multiply_by_5: purpose is to show how to declare values,
 * calculate a result, and return that result to the caller 
 * inputs:
 *      int ival - integer value we will multiply by 5
 * outputs:
 *      int result - the original input multiplied by 5
 */
int multiply_by_5(int ival);

/* fact : compute factorial of given number 
 * input: n
 * output: n!
 */
unsigned long int fact(unsigned int n);

/* do_some_math: purpose is to do math and show the outcomes for 
 * various operations that illustrate how C works
 * inputs:
 * 	int ival - integer value for performing random operations
 * 	float fval - float value for performing random operations
 * 	char cval - character showing character arithmetic
 */
void do_some_math(int ival, float fval, char cval);

#endif
