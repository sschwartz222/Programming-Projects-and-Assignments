#ifndef WARMUP4_H
#define WARMUP4_H

#include <stdio.h>
#include <stdlib.h>
#include "warmup4_provided.h"

/* count_vowels
* Count the number of vowels (a,e,i,o,u) in the string. 
* inputs:
*   char *str - char pointer to string, in parameter
* outputs:
*   returns number of vowels
*/

int count_vowels(char *str);

/* make_lowercase
* Modify the string so that all capital letters ('A'-'Z')
* are changed to their corresponding lower-case letters.
* inputs:
*   char *str - char pointer to string, 
*   in parameter and out parameter
* outputs:
*   modified string
*/

void make_lowercase(char *str);

/* make_and_init_image
* Allocates a 2-d array of pixels
* inputs:
*   int height - height of image
*   int width - width of image
*   pixel color - pixel struct containing red, green, and blue information
* ouputs:
*   2-d array of pixels
*/

pixel** make_and_init_image(int height, int width, pixel color);


#endif