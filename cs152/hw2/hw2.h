#ifndef HW2_H
#define HW2_H

#include <stdio.h>
#include <stdlib.h>

/* print_number
 * given a number, print the English version of it. 
 * inputs:
 *   int number - integer between 0 and 99
 * output:
 *   prints out, but does not return, the English of the number
 */
int print_number(int number);

/* print_hex
 * given a decimal number, print the corresponding hexadecimal number
 * inputs:
 *   unsigned int number - a decimal number
 * output:
 *   prints out, but does not return, the hexacimal number
 */
void print_hex(unsigned int number);

/* print_asterisk_word
 * given a letter, print the corresponding upper-case word in sterisks
 * inputs:
 *   char[] - a character array
 *   unsigned int length - the number of letters in the character array
 * output:
 *   prints out, but does not return, the word in the array
 */
void print_asterisk_word(char word[], unsigned int length);


/* print_asterisk_shape
 * give the height parameter, print a shape with asterisks
 * inputs:
 *   unsigned int h - height
 * output: 
 *   prints out, but not return, a shape
 */
void print_asterisk_shape(unsigned int h);

/* insert_into_array
 * given an array that has total_size allocated and currently
 * contains cur_size sorted items (in indeces 0 to cur_size-1),
 * insert value into the sorted array such that it ends up 
 * with cur_size+1 sorted items (in indeces 0 to cur_size).
 * inputs:
 *   int array[] - a sorted array
 *   unsigned int cur_size - The number of sorted items in array
 *   unsigned int total_size - The number of slots allocated in array
 *   int value - the item to place into the array
 * output:
 *   no output - change is reflected inside the array
 */
void insert_into_array(int array[], unsigned int cur_size,
			unsigned int total_size, int value);

/* sort
 * given an array of length n, sort it in place by ascending order. 
 * inputs:
 *   int source_array[] - an array that needs to be sorted
 *   int dest_array[] - the location to place the sorted numbers
 *   int size - the length of the array 
 * output:
 *   no output - the change is reflected in dest_array
 */
void sort(int source_array[], int dest_array[], unsigned int size);

#endif