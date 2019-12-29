#ifndef PNG_FUNCTIONS_H 
#define PNG_FUNCTIONS_H 

#define ROWS 50
#define COLS 50

#define QUALITY 100


/* provided_read_png
 *
 * This reads from a png file (filename) and populates the 
 * red, green, blue arrays as well as image_width and image_length.
 * out parameters:
 *  red - a 2-d array of the red component of each pixel in the picture.
     The function fills in this array with values from the picture.
 *  green - a 2-d array of the green component of each pixel in the picture.
     The function fills in this array with values from the picture.
 *  blue - a 2-d array of the blue component of each pixel in the picture.
     The function fills in this array with values from the picture.
 *  image_width - a pointer pointing to a variable in the caller's space.
 *     The function fills in the width of the picture.
 *  image_length - a pointer pointing to a variable in the caller's space.
 *     The function fills in the length of the picture.
 */
int provided_read_png(char *filename, 
    unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS], 
    unsigned int *image_width, 
    unsigned int *image_length);

/* provided_write_png
 *
 * This writes to a png file (filename) the image currently contained
 * in the red, green, and blue arrays
 * in parameters:
 *  red - a 2-d array of the red component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  green - a 2-d array of the green component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  blue - a 2-d array of the blue component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  image_width - the width of the picture.
 *  image_length - the length of the picture.
 */
int provided_write_png(char *filename, 
    unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS], 
    unsigned int image_width, 
    unsigned int image_length);

/* provided_print_image_to_html
 *
 * This writes to an html file (filename) the image currently contained
 * in the red, green, and blue arrays. You can view this html page
 * through your browser.
 * in parameters:
 *  red - a 2-d array of the red component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  green - a 2-d array of the green component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  blue - a 2-d array of the blue component of each pixel in the picture.
 *   The function reads out of this array with values from the picture.
 *  image_width - the width of the picture.
 *  image_length - the length of the picture.
 */
int provided_print_image_to_html(char *filename, 
    unsigned int red[ROWS][COLS],
    unsigned int green[ROWS][COLS],
    unsigned int blue[ROWS][COLS],
    unsigned int image_width,
    unsigned int image_height);

/* You don't need to call these functions directly... */ 
void read_png_file(char* file_name);
void write_png_file(char* file_name);
void buffer_to_arrays(unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS]);
void arrays_to_buffer(unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS]);
void free_buffer(void);
void abort_(const char * s, ...);

#endif /* PNG_FUNCTIONS_H */