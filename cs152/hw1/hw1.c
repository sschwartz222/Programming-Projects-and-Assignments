#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "hw1.h"

/* Note: You are allowed to use sqrt but not exp */

/* surface_area_pyramid
 * calculate the surface area of a pyramid consisting of 
 * four equilateral triangles (a base and three sides).
 * inputs: 
 *   double edge_length - length of one edge of the shape
 * output:
 *   double - the total surface area
 */
double surface_area_pyramid(double edge_length)
{
    if (edge_length > 0)
        return (edge_length *edge_length * sqrt(3));
	// error statement
	fprintf(stderr,"error surface_area_pyramid: edge_length cannot be negative!\n");
	return -1.0;
}

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
double sides_to_surface_area(int num_sides, double side_length)
{
    if (side_length > 0)
    {
        if (num_sides == 3)
            return (surface_area_pyramid (side_length));
        else 
        {
            if (num_sides == 4)
                return (6 * side_length * side_length);
            if (num_sides == 5)
            return (3 * sqrt(25 + (10 * sqrt(5))) * side_length * side_length);
            else
            {
                // error statement
                fprintf(stderr,"error sides_to_surface_area: invalid number of sides!\n");
                return -1.0;    
            }
        }
    }
    else
    {
        // error statement
        fprintf(stderr,"error sides_to_surface_area: invalid side length!\n");
	    return -1.0;
    }      
}


/* expt
 * linear time recursive exponentiation 
 * inputs:
 *   int a - the base
 *   unsigned int n - the exponent
 * output:
 *   long int - the calculated value
 * */
long int expt(int a, unsigned int n)
{
    if (n == 0)
    {
        return 1;
    }
    else
    {
        //recursive case
        int result = expt(a, (n - 1));
        return (result * a);
    }   
}

/* ss 
 * exponentiation by successive squaring 
 * inputs:
 *   int a - the base
 *   unsigned int n - the exponent
 * output:
 *   long int - the calculated value
 * */
long int ss(int a, unsigned int n)
{
	if (n == 0)
        return 1;
    else 
    {
        if (n%2 == 0)
        {
            // recursive even case
            int res = ss(a, (n / 2));
            return (res * res);
        }
        if (n%2 != 0)
        {
            // recursive odd case
            int res = ss(a, (n - 1));
            return (a * res);
        }
    }
}