#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "warmup2.h"

unsigned int check_print_letter(unsigned int number, char expected)
{
	char result = (print_letter(number));
	if (result == expected)
		return 1;
	else
	{	
		printf("Unexpected result (print_letter (%d)),", number);
		printf(" expected: %c, actual: %c", expected, result);
		return 0;
	}
}

int main()
{
	unsigned int num_checks = 0;
	unsigned int num_correct = 0;
	// these are here to show you how to declare, allocate, and 
	// initialize local char arrays. These are *not* strings.
	char word_rut[] = {'R','U','T'};
	char message[] = {'h','e','l','l','o',',',' ','h','o','w',' ',
		'a','r','e',' ','y','o','u','?'};
	char message2[30];
	num_correct += check_print_letter(5, 'F');
	num_checks ++;
	num_correct += check_print_letter(25, 'Z');
	num_checks ++;
	num_correct += check_print_letter(0, 'A');
	num_checks ++;
	num_correct += check_print_letter(26, ' ');
	num_checks ++;
	// eyeball tests for print_asterisk_letter
	printf("expect:\n***\n*  *\n***\n* *\n*  *\n\n");
    print_asterisk_letter('R');
	printf("expect:\n***\n*  *\n***\n* *\n*  *\n\n");
    print_asterisk_letter(82);
	printf("expect:\n ***\n*\n **\n   *\n***\n\n");
    print_asterisk_letter('S');
	printf("expect:\n*****\n  *\n  *\n  *\n  *\n\n");
    print_asterisk_letter('T');
	printf("expect:\n*   *\n*   *\n*   *\n*   *\n ***\n\n");
    print_asterisk_letter('U');
	printf("expecting an error\n");
    print_asterisk_letter(80);
	printf("expecting an error\n");
    print_asterisk_letter('A');

	// eyeball tests for the recursive wedge
	printf("expect:\n***\n****\n*****\n******\n*******\n*******\n******\n"
			"*****\n****\n***\n\n");
	draw_sideways_wedge_rec(3, 10);
	printf("expect:\n***\n****\n*****\n******\n*******\n******\n"
			"*****\n****\n***\n\n");
	draw_sideways_wedge_rec(3, 9);
	printf("expect:\n\n*\n\n\n");
	draw_sideways_wedge_rec(0, 3);
	printf("expecting nothing:\n\n");
	draw_sideways_wedge_rec(3, 0);
	printf("expect:\n**\n***\n**\n\n");
	draw_sideways_wedge_rec(2, 3);
	
	// eyeball tests for the iterative wedge
	printf("expect:\n***\n****\n*****\n******\n*******\n*******\n******\n"
			"*****\n****\n***\n\n");
	draw_sideways_wedge_iter(3, 10);
	printf("expect:\n***\n****\n*****\n******\n*******\n******\n"
			"*****\n****\n***\n\n");
	draw_sideways_wedge_iter(3, 9);
	printf("expect:\n\n*\n\n\n");
	draw_sideways_wedge_iter(0, 3);
	printf("expecting nothing:\n\n");
	draw_sideways_wedge_iter(3, 0);
	printf("expect:\n**\n***\n**\n\n");
	draw_sideways_wedge_iter(2, 3);

	printf("Passed %d out of %d tests\n",num_correct,num_checks);
}
