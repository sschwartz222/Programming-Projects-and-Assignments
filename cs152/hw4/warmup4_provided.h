#ifndef WARMUP4_PROVIDED_H
#define WARMUP4_PROVIDED_H

typedef struct {
	unsigned int red;
	unsigned int green;
	unsigned int blue;
} pixel;

void read_png_file(char* file_name);

void write_png_file(char* file_name);

void abort_(const char * s, ...);

int provided_write_png_struct(char *filename, pixel **image, int image_width, int image_height);

pixel ** provided_read_png_struct(char *filename, int *image_width, int *image_height);

#endif /* PNG_FUNCTIONS_H */