#ifndef HW1_H
#define HW1_H

// these should not be strictly necessary, since anyone
// including this file should include these first. But
// just to be safe...
#include <stdio.h>
#include <stdlib.h>

/* surface_area_pyramid
 * calculate the surface area of a pyramid consisting of 
 * four equilateral triangles (a base and three sides).
 * inputs: 
 *   double edge_length - length of one edge of the shape
 * output:
 *   double - the total surface area
 */
double surface_area_pyramid(double edge_length);

/* sides_to_surface_area
 * calculate the surface area of a shape made up of faces
 * with the specified number of sides. This function only needs
 * to support pyramid (3), cube (4), and regular dodecahedron (5).
 * In all cases, the faces have equal-length sides. A pyramid has
 * 4 faces, cube 6, and dodecahedron 12.e
 * inputs:
 *   int num_sides - number of sides of each face
 *   double side_length - length of every edge 
 * output:
 *   double - the area of a num-side polygon with given side_length
 */
double sides_to_surface_area(int num_sides, double side_length);

/* expt
 * linear time recursive exponentiation 
 * inputs:
 *   int a - the base
 *   unsigned int n - the exponent
 * output:
 *   long int - the calculated value of a^n
 * */
long int expt(int a, unsigned int n);


/* ss 
 * exponentiation by successive squaring 
 * inputs:
 *   int a - the base
 *   unsigned int n - the exponent
 * output:
 *   long int - the calculated value of a^n
 * */
long int ss(int a, unsigned int n);


#endif
