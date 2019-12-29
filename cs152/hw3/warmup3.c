#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "warmup3.h"

/* make_vertical_stripes
 * inputs: 
 *   unsigned int red[ROWS][COLS],  - red component of resulting image pixels
 *   unsigned int green[ROWS][COLS], - green component of resulting image pixels
 *   unsigned int blue[ROWS][COLS],  - blue component of resulting image pixels
 *   unsigned int stripe_width,  - width of a single stripe
 *   unsigned int stripe_red,  - red component of stripe pixel
 *   unsigned int stripe_green,  - green component of stripe pixel
 *   unsigned int stripe_blue,  - blue component of stripe pixel
 *   unsigned int width,  - width of resulting image
 *   unsigned int height); - height of resulting image
 * 
 *   This produces an image stored in the red, green, and blue 2-d arrays.
 *   The image contains black and colored stripes. All stripes are 
 *   stripe_height. The stripe colors are indicated by stripe_color.
 *   The top stripe is colored. The image is heightxwidth.
 */
int make_vertical_stripes( 
	unsigned int red[ROWS][COLS], 
	unsigned int green[ROWS][COLS], 
	unsigned int blue[ROWS][COLS], 
	unsigned int stripe_width, 
	unsigned int stripe_red, 
	unsigned int stripe_green, 
	unsigned int stripe_blue, 
	unsigned int width, 
	unsigned int height)
{
    int x, y;
    if ((width > COLS) || (height > ROWS))
    {
        fprintf(stderr, "invalid width or height");
        return 0;
    }
    else
    {
        for (x = 0; x < width; x++)
        {
            if ((stripe_width != 0) && (((x / stripe_width) % 2) == 0))
            {
                for (y = 0; y < height; y++)
                {
                    red[y][x] = stripe_red;
                    green[y][x] = stripe_green;
                    blue[y][x] = stripe_blue;
                }
            }
            else
            {
                for (y = 0; y < height; y++)
                {
                    red[y][x] = 0;
                    green[y][x] = 0;
                    blue[y][x] = 0;
                }
            }
        }
        return 1;        
    }
}

/* make_checker_board
 * inputs: 
 *   unsigned int red[ROWS][COLS],  - red component of resulting image pixels
 *   unsigned int green[ROWS][COLS], - green component of resulting image pixels
 *   unsigned int blue[ROWS][COLS],  - blue component of resulting image pixels
 *   unsigned int square_height,  - height of a single square
 *   unsigned int square_red,  - red component of square pixel
 *   unsigned int square_green,  - green component of square pixel
 *   unsigned int square_blue,  - blue component of square pixel
 *   unsigned int width,  - width of resulting image
 *   unsigned int height); - height of resulting image
 * 
 *   This produces an image stored in the red, green, and blue 2-d arrays.
 *   The image contains white and colored squares. All squares are 
 *   square_width x square_width. The square colors are indicated by 
 *   square_color. The image is heightxwidth. The top-left square is colored.
 */
int make_checker_board( 
        unsigned int red[ROWS][COLS],
        unsigned int green[ROWS][COLS],
        unsigned int blue[ROWS][COLS],
        unsigned int square_width,
        unsigned int square_red,
        unsigned int square_green,
        unsigned int square_blue,
        unsigned int width,
        unsigned int height)
{
    int x, y;
    if ((width > COLS) || (height > ROWS))
    {
        fprintf(stderr, "invalid width or height");
        return 0;
    }
    else
    {
        for (x = 0; x < width; x++)
        {
            if ((square_width != 0) && (((x / square_width) % 2) == 0))
            {
                for (y = 0; y < height; y++)
                {
                    if (((y / square_width) % 2) == 0)
                    {
                        red[y][x] = square_red;
                        green[y][x] = square_green;
                        blue[y][x] = square_blue;                        
                    }
                    else
                    {
                        red[y][x] = 255;
                        green[y][x] = 255;
                        blue[y][x] = 255;
                    }
                }
            }
            else
            {
                for (y = 0; y < height; y++)
                {
                    if ((square_width == 0) || (((y / square_width) % 2) == 0))
                    {
                        red[y][x] = 255;
                        green[y][x] = 255;
                        blue[y][x] = 255;                        
                    }
                    else
                    {
                        red[y][x] = square_red;
                        green[y][x] = square_green;
                        blue[y][x] = square_blue;                        
                    }
                }
            }
        }
        return 1;        
    }
}

/* int surface_area_and_volume 
 * input:
 *   unsigned int num_sides - number of sides
 *   double side_length - length of each side
 *   double *surface_area - surface area to be computed
 *   double *volume - volume to be computed
 * output:
 *   int - return 0 if the computation is supported,
 *   return -1 otherwise
 */
int surface_area_and_volume(unsigned int num_sides, 
    double side_length, double *surface_area, double *volume)
{
    if (side_length > 0)
    {
        if (num_sides == 3)
        {
            *surface_area = (side_length * side_length * sqrt(3));
            *volume = ((side_length * side_length * side_length) / (6 * sqrt(2)));
            return 0;
        }
        else if (num_sides == 4)
        {
            *surface_area = (6 * side_length * side_length);
            *volume = (side_length * side_length * side_length);
            return 0;
        }
        else if (num_sides == 5)
        {
            *surface_area = (3 * sqrt(25 + (10 * sqrt(5))) * side_length * side_length);
            *volume = ((side_length * side_length * side_length) * ((15 + (7 * sqrt(5))) / 4));
            return 0;
        }
        else
        {
            // error statement
            fprintf(stderr,"error sides_to_surface_area: invalid number of sides!\n");
            *surface_area = -1;
            *volume = -1;
            return -1.0;    
        }
    }
    else
    {
        // error statement
        fprintf(stderr,"error sides_to_surface_area: invalid side length!\n");
        *surface_area = -1;
        *volume = -1;
	    return -1.0;
    }      
}

/* void sort 
 * input:
 *   int array[], - array to be sorted
 *   unsigned int size - length of the array
 * this function receives an array of size elements 
 * and sort it in ascending order
 */
void sort(int array[], unsigned int size)
{
    int i, j, k;
    for (i = 1; i < size; i++)
    {
        j = (i - 1);
        k = array[i];
        while ((j >= 0) && (array[j] > k))
        {
            array[j + 1] = array[j];
            j = (j - 1);
        }
        array[j + 1] = k;
    }
}
