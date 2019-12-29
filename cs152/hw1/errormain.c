#include <stdio.h>
#include <stdlib.h>
// the quotation marks since it's a user-created file
#include "functions.h"  

/*
Principle 3: Here is a function that takes in a test case for the factorial
function
*/

int check_factorial(unsigned int input, unsigned long int expected)
{
	unsigned long int result = fact(input);
	if (expected == result)
		return 1;
	else 
	{
		printf("Test input %d expected %ld, resulted in %ld\n",
			input,expected,result);
		return 0;
	}
}

/* Principle 2: Design a good set of test cases
 * they check the base case (0), right above the base case (1), well
 * above the base case (5, 8). We would also normally check
 * error cases like -1 or -5, but because our type is unsigned int,
 * we know we won't get negative cases.
 */
int main()
{
	int num_correct = 0;  // count how many tests passed
	int num_total = 0;
	int input, output;

	printf("Your example program has begun.\n");

	/* these two are just showing function calls, 
   	 * not good programming principles */
	print_stuff(5, 7.5, 8.9, 'a');
	input = 10;
	output = multiply_by_5(input);
	printf("multiply_by_5(%d) is %d\n",input,output);
	input = 20;
	output = multiply_by_5(input);
	printf("multiply_by_5(%d) is %d\n",input,output);
	input = 0;
	output = multiply_by_5(input);
	printf("multiply_by_5(%d) is %d\n",input,output);

	printf("Now let's do some math. This illustrates some calculations in C.\n");
	do_some_math(10, 3.5, 'f');
	/* this part shows good design principles */
	num_correct += check_factorial(0, 1);
	num_total++;
	num_correct += check_factorial(1, 1);
	num_total++;
	num_correct += check_factorial(3, 6);
	num_total++;
	num_correct += check_factorial(5, 120);
	num_total++;
	num_correct += check_factorial(8, 40320);
	num_total++;
	printf("Passed %d out of %d tests\n",num_correct,num_total);

	printf("Example program exiting.\n");
}
