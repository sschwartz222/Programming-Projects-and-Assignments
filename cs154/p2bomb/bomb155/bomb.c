/***************************************************************************
 * CS 154 Project 2:  Defusing a binary "bomb"
 ***************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "support.h"
#include "phases.h"

FILE *infile;

int main(int argc, char *argv[])
{
    char *input;

    /* When run with no arguments, the bomb reads its input lines
     * from standard input. */
    if (argc == 1) {
	infile = stdin;
    }

    /* When run with one argument <file>, the bomb reads from <file>
     * until EOF, and then switches to standard input. Thus, as you
     * defuse each phase, you can add its defusing string to <file> and
     * avoid having to retype it. */
    else if (argc == 2) {
	if (!(infile = fopen(argv[1], "r"))) {
	    printf("%s: Error: Couldn't open %s\n", argv[0], argv[1]);
	    exit(8);
	}
    }

    /* You can't call the bomb with more than 1 command line argument. */
    else {
	printf("Usage: %s [<input_file>]\n", argv[0]);
	exit(8);
    }

    initialize_bomb();

    printf("Welcome to your cs154 \"bomb\". It has 6 phases, which must be\n");
    printf("\"defused\" in sequence by entering correct strings. Good luck.\n");

    input = read_line();             /* Get input                   */
    phase_1(input);                  /* Run the phase               */
    phase_defused();
    printf("Phase 1 defused. How about the next one?\n");

    input = read_line();
    phase_2(input);
    phase_defused();
    printf("Phase 2 done. Keep going!\n");

    input = read_line();
    phase_3(input);
    phase_defused();
    printf("Phase 3 cleared. Halfway there!\n");

    input = read_line();
    phase_4(input);
    phase_defused();
    printf("Phase 4 passed. Try this one.\n");

    input = read_line();
    phase_5(input);
    phase_defused();
    printf("Phase 5 finished. On to the next...\n");

    input = read_line();
    phase_6(input);
    phase_defused();

    /* All phases done.  But isn't something... missing?  Something secret,
       something extra that might have been overlooked? */

    return 0;
}
