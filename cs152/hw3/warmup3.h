#ifndef WARMUP3_H
#define WARMUP3_H

#define ROWS 50
#define COLS 50

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
    unsigned int height);

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
 * outputs:
 *   int - return 0 if failed (width or height out of range), 1 if success
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
        unsigned int height);


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
    double side_length, double *surface_area, double *volume);

/* void sort 
 * input:
 *   int array[], - array to be sorted
 *   unsigned int size - length of the array
 * this function receives an array of size elements 
 * and sort it in ascending order
 */
void sort(int array[], unsigned int size);

#endif