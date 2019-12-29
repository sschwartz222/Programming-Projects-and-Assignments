#include <stdio.h>
#include <stdlib.h>
#include "hw3_provided.h"
#include "warmup3.h"

// check for surface_area_and_volume
unsigned int check_surface_area_and_volume (unsigned int num_sides, 
    double side_length, double *surface_area, double *volume,
    double expected_sa, double expected_v)
    {
        surface_area_and_volume (num_sides, side_length, surface_area,
                                volume);
        double error_tol = 0.01;
	    if (((* surface_area >= expected_sa - error_tol) && 
		    (* surface_area <= expected_sa + error_tol)) &&
            ((* volume >= expected_v - error_tol) &&
            (* volume <= expected_v + error_tol)))
            return 1;
        else
        {
            printf("surface_area_and_volume check failed:"
                    " expected %lf and %lf, actually %lf and %lf\n",
                    expected_sa, expected_v, *surface_area, *volume);
            return 0;
        }
    }

int main()
{
	// declare variables
	unsigned int r[ROWS][COLS];
    unsigned int g[ROWS][COLS];
    unsigned int b[ROWS][COLS];
    unsigned int width = 40;
    unsigned int height = 20;
    double x, y;
    double * i = &x;
    double * j = &y;
    unsigned int num_checks = 0;
	unsigned int num_correct = 0;
    int testarr1[5] = {5, 4, 3, 2, 1};
    int testarr2[10] = {7, 3, 2, 2, 8, 10, 11, 11, 1, 0};
    int testarr3[0] = {};
    int k;

	// for the warmup, you'll call your function
	make_vertical_stripes(r,g,b,1, 30, 144, 255, width, height);
	// then print the result to html so you can see it in a browser
	provided_print_image_to_html("stripes.html",r,g,b,width,height);
	// you can also print to png so that you can use this in your hw
	provided_write_png("stripes.png",r,g,b,width,height);

    // stripe test 2
    make_vertical_stripes(r, g, b, 1, 30, 144, 255, 12, 12);
    provided_print_image_to_html("stripes2.html",r,g,b,12,12);
    provided_write_png("stripes2.png", r, g, b, 12, 12);

    // stripe test 3
    make_vertical_stripes(r, g, b, 5, 30, 144, 255, 50, 50);
    provided_print_image_to_html("stripes3.html", r, g, b, 50, 50);
    provided_write_png("stripes3.png", r, g, b, 50, 50);

    // stripe test 4
    make_vertical_stripes(r, g, b, 0, 30, 144, 255, 50, 50);
    provided_print_image_to_html("stripes4.html", r, g, b, 50, 50);
    provided_write_png("stripes4.png", r, g, b, 50, 50);
	width = 50;
	height = 50;

    // checkerboard test 1
	make_checker_board(r,g,b,3, 90, 100, 255, width, height);
	provided_print_image_to_html("checker.html",r,g,b,width,height);
    provided_write_png("checker.png", r,g,b,width,height);

    // checkerboard test 2
    make_checker_board(r,g,b,4,30,144,255, 12, 12);
    provided_print_image_to_html("checker2.html", r, g, b, 12, 12);
    provided_write_png("checker2.png", r, g, b, 12, 12);

    // checkerboard test 3
    make_checker_board(r,g,b,0,30,144,255, 12, 12);
    provided_print_image_to_html("checker3.html", r, g, b, 12, 12);
    provided_write_png("checker3.png", r, g, b, 12, 12);

	// then put test cases for your other functions here
    num_correct += check_surface_area_and_volume(3, 3, i, j, 15.59, 3.18);
	num_checks ++;
	num_correct += check_surface_area_and_volume(4, 3, i, j, 54, 27);
	num_checks ++;
	num_correct += check_surface_area_and_volume(5, 3, i, j, 185.81, 206.9);
	num_checks ++;
    num_correct += check_surface_area_and_volume(6, 3, i, j, -1, -1);
	num_checks ++;

    // test 1 for sort
    printf("original: ");
    for (k = 0; k < 5; k++)
        printf("%d ", testarr1[k]);
    printf("\n");
    printf("sorted: ");
    sort(testarr1, 5);
    for (k = 0; k < 5; k++)
        printf("%d ", testarr1[k]);
    printf("\n");

    // test 2 for sort
    printf("orignal: ");
    for (k = 0; k < 10; k++)
        printf("%d ", testarr2[k]);
    printf("\n");
    printf("sorted: ");
    sort(testarr2, 10);
    for (k = 0; k < 10; k++)
        printf("%d ", testarr2[k]);
    printf("\n");

    // test 3 for sort
    printf("original is empty, expect nothing: \n");
    sort(testarr3, 0);
    for (k = 0; k < 0; k++)
        printf("%d ", testarr2[k]);
    printf("\n");


    printf("Passed %d out of %d tests\n",num_correct,num_checks);
    
	
	// when you get to the hw, you'll also need the ability to read
	// in a png file. Here is how you do it - put in the filename
	// of the file you want to read, pass in your r,g,b arrays 
	// to be filled in by the function, and then also pass in the
	// addresses of width and height so that the values for the 
	// actual width and height can be filled in for you.
	// for example, if you read in stripes.png
	//provided_read_png("stripes.png",r,g,b,&width,&height);
	//printf("stripes.png is height: %u, width: %u\n", width, height);
	//provided_read_png("checker_board.png",r,g,b,&width,&height);
	//printf("checker_board.png is height: %u, width: %u\n", width, height);

}
