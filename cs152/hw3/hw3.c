#include <stdio.h>
#include <stdlib.h>
#include "hw3_provided.h"
#include "hw3.h"

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
	unsigned int height, unsigned int width)
    {
        int x, y;
        if ((width > COLS) || (height > ROWS))
        {
            fprintf(stderr, "invalid width or height\n");
        }
        else
        {
            for (x = 0; x < width; x++)
            {
                for (y = 0; y < height; y++)
                {
                    if ((hid_r[y][x] >= 128) && ((ref_r[y][x] % 2) == 0))
                        (res_r[y][x] = (res_r[y][x] + 1));
                    if ((hid_g[y][x] >= 128) && ((ref_g[y][x] % 2) == 0))
                        (res_g[y][x] = (res_g[y][x] + 1));
                    if ((hid_b[y][x] >= 128) && ((ref_b[y][x] % 2) == 0))
                        (res_b[y][x] = (res_b[y][x] + 1));                                        
                    if ((hid_r[y][x] < 128) && ((ref_r[y][x] % 2) != 0))
                        (res_r[y][x] = (res_r[y][x] - 1));
                    if ((hid_g[y][x] < 128) && ((ref_g[y][x] % 2) != 0))
                        (res_g[y][x] = (res_g[y][x] - 1));
                    if ((hid_b[y][x] < 128) && ((ref_b[y][x] % 2) != 0))
                        (res_b[y][x] = (res_b[y][x] - 1));
                }
            }
        } 
    }

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
	unsigned int height, unsigned int width)
    {
        int x, y;
        for (x = 0; x < width; x++)
        {
            for (y = 0; y < height; y++)
            {
                if ((res_r[y][x] % 2) == 0)
                    hid_r[y][x] = 0;
                if ((res_g[y][x] % 2) == 0)
                    hid_g[y][x] = 0;
                if ((res_b[y][x] % 2) == 0)
                    hid_b[y][x] = 0;
                if ((res_r[y][x] % 2) != 0)
                    hid_r[y][x] = 255;
                if ((res_g[y][x] % 2) != 0)
                    hid_g[y][x] = 255;
                if ((res_b[y][x] % 2) != 0)
                    hid_b[y][x] = 255;
            }
        }
    }

/* void encode
* inputs:
* char *ref_filename - image to hide things in
* char *hid_filename - image to hide
* char *enc_filename - place to store encoded image
* hides an image in another image by calling hide_image
* and stores the result in the enc_filename
* *enc_filname is an out parameter
*/

void encode(char *ref_filename, char *hid_filename, char *enc_filename)
{
    unsigned int refr[ROWS][COLS];
    unsigned int refg[ROWS][COLS];
    unsigned int refb[ROWS][COLS];
	unsigned int hidr[ROWS][COLS];
    unsigned int hidg[ROWS][COLS];
    unsigned int hidb[ROWS][COLS];
	unsigned int encr[ROWS][COLS];
    unsigned int encg[ROWS][COLS];
    unsigned int encb[ROWS][COLS];
    unsigned int wid, hgt;
    unsigned int * w = &wid;
    unsigned int * h = &hgt;
    provided_read_png(ref_filename, refr, refg, refb, &wid, &hgt);
    provided_read_png(hid_filename, hidr, hidg, hidb, &wid, &hgt);
    provided_write_png(enc_filename, refr, refg, refb, *w, *h);
    provided_read_png(enc_filename, encr, encg, encb, &wid, &hgt);
    hide_image(refr, refg, refb, hidr, hidg, hidb, encr, encg, encb, 
                *h, *w);
    provided_write_png(enc_filename, encr, encg, encb, *w, *h);
}

/* void decode
* inputs:
* char *enc_filename - place to store encoded image
* char *hid_filename - image to hide
* reveals an image in another image by calling extract_image
* and stores the result in the hid_filename
* *hid_filname is an out parameter
*/
void decode(char *enc_filename, char *hid_filename)
{
	unsigned int hidr[ROWS][COLS];
    unsigned int hidg[ROWS][COLS];
    unsigned int hidb[ROWS][COLS];
	unsigned int encr[ROWS][COLS];
    unsigned int encg[ROWS][COLS];
    unsigned int encb[ROWS][COLS];    
    unsigned int wid, hgt;
    unsigned int * w = &wid;
    unsigned int * h = &hgt;
    provided_read_png(enc_filename, encr, encg, encb, &wid, &hgt);
    provided_read_png(hid_filename, hidr, hidg, hidb, &wid, &hgt);
    extract_image(encr, encg, encb, hidr, hidg, hidb, *h, *w);
    provided_write_png(hid_filename, hidr, hidg, hidb, *w, *h);
}