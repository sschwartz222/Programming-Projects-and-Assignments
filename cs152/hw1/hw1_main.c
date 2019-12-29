#include <stdio.h>
#include <stdlib.h>
#include "hw1.h"  // see how we're including the file again?

// you will need to implement check functions here
unsigned int check_surface_area_pyramid(double length,
					double expected_result)
{
	double dresult = surface_area_pyramid(length);
	double error_tolerance = 0.01;
	if ((dresult >= expected_result - error_tolerance) && 
		(dresult <= expected_result + error_tolerance))
	{
		return 1;
	}
	else
	{
		printf("Unexpected result. surface_area_pyramid(%lf)",
			length);
		printf("returned %lf, expected %lf\n",dresult, expected_result);
		return 0;
	}
}

// check for sides_to_surface_area
unsigned int check_sides_to_surface_area(int nsides, 
					double len, double exp_res)
{
    double dres = sides_to_surface_area(nsides, len);
    double error_tol = 0.01;
	if ((dres >= exp_res - error_tol) && 
		(dres <= exp_res + error_tol))
	{
		return 1;
	}
	else
	{
		printf("Unexpected result. side_to_surface_area(%lf)",
			len);
		printf("returned %lf, expected %lf\n",dres, exp_res);
		return 0;
	}
}
// you will need to implement check functions here
unsigned int check_expt(int a, unsigned int n,
					long int expected_result)
{
	long int expt_result = expt(a, n);
	if (expt_result == expected_result) {
		return 1;
	} else {
		printf("Unexpected result. expt(%d, %u)", a, n);
		printf("returned %ld, expected %ld\n", expt_result, expected_result);
		return 0;
	}
}

// you will need to implement check functions here
unsigned int check_ss(int a, unsigned int n,
					long int expected_result)
{
	long int ss_result = ss(a, n);
	if (ss_result == expected_result) {
		return 1;
	} else {
		printf("Unexpected result. ss(%d, %u)", a, n);
		printf("returned %ld, expected %ld\n", ss_result, expected_result);
		return 0;
	}
}


int main()
{
	unsigned int num_checks = 0;
	unsigned int num_correct = 0;
	// surface_area_pyramid checks
	num_correct += check_surface_area_pyramid(3, 15.59);
	num_checks ++;
	num_correct += check_surface_area_pyramid(0, -1.0);
	num_checks ++;
	num_correct += check_surface_area_pyramid(1, 1.73);
	num_checks ++;
	// sides_to_surface_area checks
	num_correct += check_sides_to_surface_area(0, 3, -1.0);
	num_checks ++;
	num_correct += check_sides_to_surface_area(3, 0, -1.0);
	num_checks ++;
	num_correct += check_sides_to_surface_area(3, 3, 15.59);
	num_checks ++;
	num_correct += check_sides_to_surface_area(4, 3, 54.0);
	num_checks ++;
	num_correct += check_sides_to_surface_area(5, 3, 185.81);
	num_checks ++;
	// expt checks
	num_correct += check_expt(2, 0, 1);
	num_checks ++;
	num_correct += check_expt(2, 3, 8);
	num_checks ++;
	num_correct += check_expt(7, 10, 282475249);
	num_checks ++;
	// ss checks
	num_correct += check_ss(2, 0, 1);
	num_checks ++;
	num_correct += check_ss(2, 3, 8);
	num_checks ++;
	num_correct += check_ss(7, 10, 282475249);
	num_checks ++;

	printf("Passed %d out of %d tests\n",num_correct,num_checks);
}
