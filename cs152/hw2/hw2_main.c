#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hw2.h"  

int main()
{
	int par_sorted_array[] = {3, 7, 9, 0, 0, 0};
	int s_array[] = {3, 5, 2, 4, 1};
  int s2_array[] = {10, 40, 39, 38, 37, 36};
	int d_array[5] = {100, 100, 100, 100, 100};
  int d2_array[6] = {100, 100, 100, 100, 100};
  char word_rut[] = {'r', 'u', 't'};
  char word_rust[] = {'r', 'u', 's', 't'};
  char word_test[0];
  int j;
	
  //exercise 1: print numbers
  printf("expect print_number(12): twelve\n");
  print_number(12);
  printf("expect print_number(40): forty\n");
  print_number(40);
  printf("expect print_number(0): zero\n");
  print_number(0);
  printf("expect print_number(9): nine\n");
  print_number(9);
  printf("expect print_number(87): eighty-seven\n");
  print_number(87);
  printf("expect print_number(100): error\n");
  print_number(100);
  printf("expect print_number(99): ninety-nine\n");
  print_number(99);

  //exercise 2: convert decimal to hexadecimal
  printf("expect print_hex(31) = 1f\n");
  print_hex(31);
  printf("\n");
  printf("expect print_hex(32) = 20\n");
  print_hex(32);
  printf("\n");
  printf("expect print_hex(15) = f\n");
  print_hex(15);
  printf("\n");
  printf("expect print_hex(100) = 64\n");
  print_hex(100);
  printf("\n");
  printf("expect print_hex(320) = 140\n");
  print_hex(320);
  printf("\n");

  //exercise 3: print_asterisk_word
  printf("expect print_asterisk_word(word_rut, 3):"
          "\n***  *   * ***** \n*  * *   *   *   \n"
          "***  *   *   *   \n* *  *   *   *   \n*  *  ***    *   \n\n");
  print_asterisk_word(word_rut, 3);
  printf("expect print_asterisk_word(word_rust, 4):"
          "\n***  *   *  *** ***** \n*  * *   * *      *   \n"
          "***  *   *  **    *   \n* *  *   *    *   *   \n"
          "*  *  ***  ***    *   \n\n");
  print_asterisk_word(word_rust, 4);
  printf("expect print_asterisk_word(word_test, 0): nothing\n");
  print_asterisk_word(word_test, 0);
  printf("test\n");
  print_asterisk_word("ff", 2);
  printf("\n end test\n");

  //exercise 4: print_asterisk_word
  printf("expect print_asterisk_shape(5):\n");
  printf("*        *\n"
         "**      **\n"
         "***    ***\n"
         "****  ****\n"
         "**********\n"
         "**********\n"
         "**********\n"
         "**********\n"
         "**********\n"
         "**********\n"
         "**********\n"
         " ******** \n"
         "  ******  \n"
         "   ****   \n"
         "    **    \n\n");
  print_asterisk_shape(5);
  printf("expect print_asterisk_shape(41): error\n\n");
  print_asterisk_shape(41);
  printf("\n");
  printf("expect print_asterisk_shape(1):\n"
          "**\n**\n**\n\n");
  print_asterisk_shape(1);

  //exercise 5a: insert_into_array
  printf("original array: 3 7 9 0 0 0\n"
          "expect insert_into_array(par_sorted_array, 3, 6, 4):"
          " 3 4 7 9 0 0\n\n");
  insert_into_array(par_sorted_array, 3, 6, 4); 
  for (j = 0; j < 6; j++)
    printf("%d ", par_sorted_array[j]);
  printf("\n\n");
  printf("original array: 3 4 7 9 0 0\n"
          "expect insert_into_array(par_sorted_array, 4, 6, 1):"
          " 1 3 4 7 9 0\n\n");
  insert_into_array(par_sorted_array, 4, 6, 1);
  for (j = 0; j < 6; j++)
    printf("%d ", par_sorted_array[j]);
  printf("\n\n");

  //exercise 5b: sort
  printf("original array: ");
  for (j = 0; j < 6; j++)
    printf("%d ", s2_array[j]);
  printf("\n");
  printf("expect sort(s2_array, d2_array, 6): ");
  printf("10 36 37 38 39 40\n\n");
  sort(s2_array, d2_array, 6);
  printf("\n\n");
  printf("original array: ");
  for (j = 0; j < 5; j++)
    printf("%d ", s_array[j]);
  printf("\n");
  printf("expect sort(s_array, d_array, 5): ");
  printf("1 2 3 4 5\n\n");
  sort(s_array, d_array, 5);
  printf("\n\n");
}
