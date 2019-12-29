#ifndef WARMUP2_H
#define WARMUP2_H

/* print_letter
 * input: uint number - the position in the alphabet of the letter to print
 * output: character that was printed to the screen.
 * summary: Given a number, print the corresponding capital letter 
 * of the alphabet. The number can be anything from 0 to 25. 0 prints 
 * out 'A', 1 prints out 'B', 2 prints out 'C', etc. It also returns 
 * the character.
 */
char print_letter(unsigned int number);

/* print_asterisk_letter
 * input: char letter - the letter to print out
 * output: nothing returned, just printed to the screen.
 * Given a character, print the corresponding upper-case letter of the 
 * alphabet using asterisks. 
 */
void print_asterisk_letter(char letter);

/* draw_sideways_wedge_rec
 * input: unsigned int width, unsigned int height - width and height
 * of the wedge
 * output: nothing returned, just printed to the screen.
 * Given a width and height, draws a sideways wedge recursively
 */
void draw_sideways_wedge_rec(unsigned int width, unsigned int height);
void draw_row(unsigned int length);
void going_up(unsigned int wid, unsigned int counter, unsigned int hi);
void going_down(unsigned int wid, unsigned int counter, unsigned int hi);


/* draw_sideways_wedge_iter
 * input: unsigned int width, unsigned int height - width and height
 * of the wedge
 * output: nothing returned, just printed to the screen.
 * Given a width and height, draws a sideways wedge iteratively
 */
void draw_sideways_wedge_iter(unsigned int width, unsigned int height);

#endif


