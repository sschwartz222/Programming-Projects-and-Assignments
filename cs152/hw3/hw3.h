#ifndef HW3_H
#define HW3_H

#define ROWS 50
#define COLS 50

/* void hide_image
* inputs:
*	unsigned int ref_r[ROWS][COLS], - reference's red values
*	unsigned int ref_g[ROWS][COLS], - reference's green values
*	unsigned int ref_b[ROWS][COLS], - reference's blue values
*	unsigned int hid_r[ROWS][COLS], - hidden's red values
*	unsigned int hid_g[ROWS][COLS], - hidden's green values
*	unsigned int hid_b[ROWS][COLS], - hidden's blue values
*	unsigned int res_r[ROWS][COLS], - result's red values
*	unsigned int res_g[ROWS][COLS], - result's green values
*	unsigned int res_b[ROWS][COLS], - result's blue values
*	unsigned int height, - image height
*   unsigned int width - image width
* hides an image in another image by altering the resulting
* image's rgb values by at most 1
* res_r, res_g, res_b are out parameters
*/
void hide_image(
	unsigned int ref_r[ROWS][COLS], 
	unsigned int ref_g[ROWS][COLS], 
	unsigned int ref_b[ROWS][COLS], 
	unsigned int hid_r[ROWS][COLS], 
	unsigned int hid_g[ROWS][COLS], 
	unsigned int hid_b[ROWS][COLS], 
	unsigned int res_r[ROWS][COLS], 
	unsigned int res_g[ROWS][COLS], 
	unsigned int res_b[ROWS][COLS], 
	unsigned int height, unsigned int width);

/* void extract_image
* inputs:
*	unsigned int res_r[ROWS][COLS], - result's red values
*	unsigned int res_g[ROWS][COLS], - result's green values
*	unsigned int res_b[ROWS][COLS], - result's blue values
*	unsigned int hid_r[ROWS][COLS], - hidden's red values
*	unsigned int hid_g[ROWS][COLS], - hidden's green values
*	unsigned int hid_b[ROWS][COLS], - hidden's blue values
*	unsigned int height, - image height
*   unsigned int width - image width
* extracts an image in another image by determining if the resulting
* image's rgb values are even or odd
* hid_r, hid_g, hid_b are out parameters
*/
void extract_image(
	unsigned int res_r[ROWS][COLS], 
	unsigned int res_g[ROWS][COLS], 
	unsigned int res_b[ROWS][COLS], 
	unsigned int hid_r[ROWS][COLS], 
	unsigned int hid_g[ROWS][COLS], 
	unsigned int hid_b[ROWS][COLS], 
	unsigned int height, unsigned int width);

/* void encode
* inputs:
* char *ref_filename - image to hide things in
* char *hid_filename - image to hide
* char *enc_filename - place to store encoded image
* hides an image in another image by calling hide_image
* and stores the result in the enc_filename
* *enc_filname is an out parameter
*/
void encode(char *ref_filename, char *hid_filename, char *enc_filename);

/* void decode
* inputs:
* char *enc_filename - place to store encoded image
* char *hid_filename - image to hide
* reveals an image in another image by calling extract_image
* and stores the result in the hid_filename
* *hid_filname is an out parameter
*/
void decode(char *enc_filename, char *hid_filename);

#endif