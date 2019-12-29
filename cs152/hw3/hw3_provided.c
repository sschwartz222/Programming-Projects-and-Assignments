//These functions are provided from the following sources:
/*
 * Copyright 2002-2010 Guillaume Cottenceau.
 *
 * This software may be freely redistributed under the terms
 * of the X11 license.
 *
 */
// LibPNG example
// A.Greensted
// http://www.labbookpages.co.uk


#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#define PNG_DEBUG 3
#include <png.h>

#include "hw3_provided.h"

void abort_(const char * s, ...)
{
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
        fprintf(stderr, "\n");
        va_end(args);
        abort();
}

int x, y;

int width, height;
png_byte color_type;
png_byte bit_depth;

png_structp png_ptr;
png_infop info_ptr;
int number_of_passes;
png_bytep * row_pointers;

void read_png_file(char* file_name)
{
        unsigned char header[8];    // 8 is the maximum size that can be checked

        /* open file and test for it being a png */
        FILE *fp = fopen(file_name, "rb");
        if (!fp)
                abort_("[read_png_file] File %s could not be opened for reading", file_name);
        fread(header, 1, 8, fp);
        if (png_sig_cmp(header, 0, 8))
                abort_("[read_png_file] File %s is not recognized as a PNG file", file_name);


        /* initialize stuff */
        png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (!png_ptr)
                abort_("[read_png_file] png_create_read_struct failed");

        info_ptr = png_create_info_struct(png_ptr);
        if (!info_ptr)
                abort_("[read_png_file] png_create_info_struct failed");

        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[read_png_file] Error during init_io");

        png_init_io(png_ptr, fp);
        png_set_sig_bytes(png_ptr, 8);

        png_read_info(png_ptr, info_ptr);

        width = png_get_image_width(png_ptr, info_ptr);
        height = png_get_image_height(png_ptr, info_ptr);
        color_type = png_get_color_type(png_ptr, info_ptr);
        bit_depth = png_get_bit_depth(png_ptr, info_ptr);

        number_of_passes = png_set_interlace_handling(png_ptr);
        png_read_update_info(png_ptr, info_ptr);


        /* read file */
        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[read_png_file] Error during read_image");

        row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
        for (y=0; y<height; y++)
                row_pointers[y] = (png_byte*) malloc(png_get_rowbytes(png_ptr,info_ptr));

        png_read_image(png_ptr, row_pointers);

        fclose(fp);
}


void write_png_file(char* file_name)
{
        /* create file */
        FILE *fp = fopen(file_name, "wb");
        if (!fp)
                abort_("[write_png_file] File %s could not be opened for writing", file_name);


        /* initialize stuff */
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);

        if (!png_ptr)
                abort_("[write_png_file] png_create_write_struct failed");

        info_ptr = png_create_info_struct(png_ptr);
        if (!info_ptr)
                abort_("[write_png_file] png_create_info_struct failed");

        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[write_png_file] Error during init_io");

        png_init_io(png_ptr, fp);


        /* write header */
        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[write_png_file] Error during writing header");

        png_set_IHDR(png_ptr, info_ptr, width, height,
                     bit_depth, color_type, PNG_INTERLACE_NONE,
                     PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

        png_write_info(png_ptr, info_ptr);


        /* write bytes */
        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[write_png_file] Error during writing bytes");

        png_write_image(png_ptr, row_pointers);


        /* end write */
        if (setjmp(png_jmpbuf(png_ptr)))
                abort_("[write_png_file] Error during end of write");

        png_write_end(png_ptr, NULL);

        /* cleanup heap allocation */
        for (y=0; y<height; y++)
                free(row_pointers[y]);
        free(row_pointers);

        fclose(fp);
}


void buffer_to_arrays(unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS])
{
        /*
        if (png_get_color_type(png_ptr, info_ptr) == PNG_COLOR_TYPE_RGB)
                abort_("[process_file] input file is PNG_COLOR_TYPE_RGB but must be PNG_COLOR_TYPE_RGBA "
                       "(lacks the alpha channel)");
            */
        if (png_get_color_type(png_ptr, info_ptr) != PNG_COLOR_TYPE_RGB)
                abort_("[process_file] color_type of input file must be PNG_COLOR_TYPE_RGB (%d) (is %d)",
                       PNG_COLOR_TYPE_RGB, png_get_color_type(png_ptr, info_ptr));
	int read_width = width > COLS? COLS : width;
	int read_height = height > ROWS? ROWS : height;       

        for (y=0; y<read_height; y++) {
                png_byte* row = row_pointers[y];
                for (x=0; x<read_width; x++) {
                        png_byte* ptr = &(row[x*3]);
                        //printf("Pixel at position [ %d - %d ] has RGBA values: %d - %d - %d\n",
                        //       x, y, ptr[0], ptr[1], ptr[2]);
                        red[y][x] = ptr[0];
                        green[y][x] = ptr[1];
                        blue[y][x] = ptr[2];

                }
        }
}

void arrays_to_buffer(unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS])
{
    row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
    int read_width = width > COLS? COLS : width;
    int read_height = height > ROWS? ROWS : height;       

    for (y=0; y<read_height; y++) 
    {
        png_byte* row = (png_bytep) malloc(3 * width * sizeof(png_byte));
        for (x=0; x<read_width; x++) 
        {
                png_byte* ptr = &(row[x*3]);
                //printf("Pixel at position [ %d - %d ] has RGBA values: %d - %d - %d\n",
                //       x, y, ptr[0], ptr[1], ptr[2]);
                ptr[0] = (unsigned char) red[y][x];
                ptr[1] = (unsigned char) green[y][x];
                ptr[2] = (unsigned char) blue[y][x];

        }

        row_pointers[y] = row;
    }
}

void free_buffer(void)
{
    for (y=0; y<height; y++)
        free(row_pointers[y]);

    free(row_pointers);
}

int provided_read_png(char *filename, 
    unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS], 
    unsigned int *image_width, 
    unsigned int *image_length)
{
    read_png_file(filename);
    *image_width=width>COLS?COLS:width;
    *image_length=height>ROWS?ROWS:height;
    buffer_to_arrays(red, green, blue);
    free_buffer();
    return 1;
}

int provided_write_png(char *filename, 
    unsigned int red[ROWS][COLS], 
    unsigned int green[ROWS][COLS], 
    unsigned int blue[ROWS][COLS], 
    unsigned int image_width, 
    unsigned int image_length)
{
    width=image_width;
    height=image_length;
    color_type = PNG_COLOR_TYPE_RGB;
    bit_depth = 8;

    arrays_to_buffer(red,green,blue);
    write_png_file(filename);
    return 1;
}

int provided_print_image_to_html(char *filename, unsigned int red[ROWS][COLS],
        unsigned int green[ROWS][COLS],
        unsigned int blue[ROWS][COLS],
        unsigned int image_width,
        unsigned int image_height)
{
    FILE *fp;
    int i, j;
    fp = fopen(filename,"w");
    if (!fp)
    {
            fprintf(stderr,"error: could not open file %s\n",filename);
            return 0;
    }

    fprintf(fp,"<html>\n");
    fprintf(fp,"<table border=0 cellpadding=0 cellspacing=0>");
    // print out all of the pixels, row by row, one per line
    for(i=0;i<image_height;i++)
    {
        fprintf(fp,"<!-- ROW %d -->\n",i);
        fprintf(fp,"<tr align=center style=\"height:15px\">\n");
                for(j=0;j<image_width;j++)
                {
                        fprintf(fp,"   <td style=\"width:15px\"");
            fprintf(fp," bgcolor=\"#%.2x%.2x%.2x",
                red[i][j],green[i][j],blue[i][j]);
            fprintf(fp,"\">&nbsp;</td>\n");
                }
        fprintf(fp,"</tr>\n");
    }
    fprintf(fp,"</table>\n");

    fprintf(fp,"</html>\n");
    fclose(fp);
    return 1;
}