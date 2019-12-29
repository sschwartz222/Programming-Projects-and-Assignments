#include <stdio.h>
#include <stdlib.h>
#include "warmup4_provided.h"
#include "warmup4.h"


/* count_vowels
* Count the number of vowels (a,e,i,o,u) in the string. 
* inputs:
*   char *str - char pointer to string, in parameter
* outputs:
*   returns number of vowels
*/

int count_vowels(char *str)
{
    int counter = 0;
    int i;
    if (str == NULL)
        fprintf(stderr, "ERROR: empty string");
    else
    {
        for(i = 0; str[i] != '\0'; i++)
        {
            if ((str[i] == 'a') || (str[i] == 'e') || (str[i] == 'i') ||
                (str[i] == 'o') || (str[i] == 'u') || (str[i] == 'A') || (str[i] == 'E') ||
                (str[i] == 'I') || (str[i] == 'O') || (str[i] == 'U'))
                counter += 1;
        }
    }
    return counter; 
}

/* make_lowercase
* Modify the string so that all capital letters ('A'-'Z')
* are changed to their corresponding lower-case letters.
* inputs:
*   char *str - char pointer to string, 
*   in parameter and out parameter
* outputs:
*   modified string
*/

void make_lowercase(char *str)
{
    int i;
    if (str == NULL)
    {
        printf("ERROR: empty string");
        return;
    }
    else
    {
        for(i = 0; str[i] != '\0'; i++)
        {
            if ((str[i] >= 65) && (str[i] <= 90))
                *(str + i) += 32;
        }
    }      
}

/* make_and_init_image
* Allocates a 2-d array of pixels
* inputs:
*   int height - height of image
*   int width - width of image
*   pixel color - pixel struct containing red, green, and blue information
* ouputs:
*   2-d array of pixels
*/

pixel** make_and_init_image(int height, int width, pixel color)
{
    int i, j;
    pixel **image;
    image = (pixel **) malloc(height * (sizeof(pixel *)));
    for (i = 0; i < height; i++)
    {
        pixel *row;
        row = malloc(width * (sizeof(pixel)));
        for (j = 0; j < width; j++)
            row[j] = color;
        image[i] = row;
    }
    return image;
}