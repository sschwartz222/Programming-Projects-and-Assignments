#include <stdlib.h>
#include <stdio.h>
#include "warmup2.h"

/* print_letter
 * input: uint number - the position in the alphabet of the letter to print
 * output: character that was printed to the screen.
 * summary: Given a number, print the corresponding capital letter 
 * of the alphabet. The number can be anything from 0 to 25. 0 prints 
 * out 'A', 1 prints out 'B', 2 prints out 'C', etc. It also returns 
 * the character.
 */
char print_letter(unsigned int number)
{ 
    char letter = number + 65;
	if (number > 25)
    {
        fprintf(stderr, "ERROR: print_letter: Received input %u, "
                        "between 0 and 25 expected.\n", number);
        letter = 32; 
        return letter;
    }
    else
    {
        printf("%c\n", letter);
        return letter;
    }
}

/* print_asterisk_letter
 * input: char letter - the letter to print out
 * output: nothing returned, just printed to the screen.
 * Given a character, print the corresponding upper-case letter of the 
 * alphabet using asterisks. You only need to support the ones specified
 * in the assignment description, not all letters.
 */
void print_asterisk_letter(char letter)
{
    char *letters[] = 
        {"***\n*  *\n***\n* *\n*  *\n",
        " ***\n*\n **\n   *\n***\n",
        "*****\n  *\n  *\n  *\n  *\n",
        "*   *\n*   *\n*   *\n*   *\n ***\n"};
    if ((letter > 81) && (letter < 86))
    {
        printf("%s\n", letters[letter - 82]);
    }
    else
    {
        fprintf(stderr, "ERROR: print_asterisk_letter: "
                        "Received input %c, Between R and U expected.\n", 
                        letter);
    }
}

/* draw_sideways_wedge_rec
 * input: unsigned int width, unsigned int height - width and height
 * of the wedge
 * output: nothing returned, just printed to the screen.
 * Given a width and height, draws a sideways wedge recursively
 */
// helper to draw a row of asterisks of length 
void draw_row(unsigned int length)
{
    if (length > 0)
    {
        printf("*");
        draw_row(length - 1);
    }
    else
    {
        printf("\n");
    }
}

void going_up(unsigned int wid, unsigned int counter, unsigned int hi)
{
    if (counter < hi)
    {
        draw_row(wid);
        counter++;
        going_up((wid + 1), counter, hi);
    }
    return;
}

void going_down(unsigned int wid, unsigned int counter, unsigned int hi)
{
    if (counter < ((hi + 1) / 2))
    {
        draw_row(wid + ((hi - 1)/ 2) - counter);
        counter++;
        going_down(wid, counter, hi);
    }
    return;
}

void draw_sideways_wedge_rec(unsigned int width, unsigned int height)
{
    unsigned int a = (height / 2);
    going_up(width, 0, a);
    going_down(width, 0, height);
    printf("\n");
}

/* draw_sideways_wedge_iter
 * input: unsigned int width, unsigned int height - width and height
 * of the wedge
 * output: nothing returned, just printed to the screen.
 * Given a width and height, draws a sideways wedge iteratively
 */
void draw_sideways_wedge_iter(unsigned int width, unsigned int height)
{
    unsigned int i, j;
    for (i = 0; i < height; i++)
    {
        if (i < (height / 2))
        {
            for (j = 0; j < (width + i); j++)
                printf("*");
            printf("\n");
        }
        else
        {
            for (j = 0; j < (width + (height - i - 1)); j++)
                printf("*");
            printf("\n");
        }
    }
}
