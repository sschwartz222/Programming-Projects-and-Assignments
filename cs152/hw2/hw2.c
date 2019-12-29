#include <stdio.h>
#include <stdlib.h>
#include "hw2.h"

/* print_number
 * given a number, print the English version of it. 
 * inputs:
 *   int number - integer between 0 and 99
 * output:
 *   prints out, but does not return, the English of the number
 */

int print_number(int number)
{
    int a = number % 10;
    int b = ((number - a) / 10);
    if ((number >= 0) && (number <= 99))
    {
        if (number == 0)
        {
            printf("zero\n");
            return 0;
        }
        else if (a == 0)
        {
            switch (b)
            {
                case 1:
                    printf("ten\n");
                    return 0;
                case 2:
                    printf("twenty\n");
                    return 0;
                case 3:
                    printf("thirty\n");
                    return 0;
                case 4:
                    printf("forty\n");
                    return 0;
                case 5:
                    printf("fifty\n");
                    return 0;
                case 6:
                    printf("sixty\n");
                    return 0;
                case 7:
                    printf("seventy\n");
                    return 0;
                case 8:
                    printf("eighty\n");
                    return 0;
                case 9:
                    printf("ninety\n");
                    return 0; 
            }
        }
        else
        {
            switch (b)
            {
                case 0:
                    printf("");
                    break;
                case 1:
                    switch (a)
                    {
                        case 1: 
                            printf("eleven\n");
                            break;
                        case 2: 
                            printf("twelve\n");
                            break;
                        case 3:
                            printf("thirteen\n");
                            break;
                        case 4:
                            printf("fourteen\n");
                            break;
                        case 5:
                            printf("fifteen\n");
                            break;
                        case 6:
                            printf("sixteen\n");
                            break;
                        case 7:
                            printf("seventeen\n");
                            break;
                        case 8:
                            printf("eighteen\n");
                            break;
                        case 9:
                            printf("nineteen\n");
                            break;
                    }
                    return 0;
                case 2:
                    printf("twenty-");
                    break;
                case 3:
                    printf("thirty-");
                    break;
                case 4:
                    printf("forty-");
                    break;
                case 5:
                    printf("fifty-");
                    break;
                case 6:
                    printf("sixty-");
                    break;
                case 7:
                    printf("seventy-");
                    break;
                case 8:
                    printf("eighty-");
                    break;
                case 9:
                    printf("ninety-");
                    break; 
            }
            switch (a)
            {
                case 1: 
                    printf("one\n");
                    return 0;
                case 2: 
                    printf("two\n");
                    return 0;
                case 3:
                    printf("three\n");
                    return 0;
                case 4:
                    printf("four\n");
                    return 0;
                case 5:
                    printf("five\n");
                    return 0;
                case 6:
                    printf("six\n");
                    return 0;
                case 7:
                    printf("seven\n");
                    return 0;
                case 8:
                    printf("eight\n");
                    return 0;
                case 9:
                    printf("nine\n");
                    return 0;
            }
        }
    }
    else
    {
        fprintf(stderr, "error (print_number): number out of allowed range\n");
        return -1;
    } 
}

/* print_hex
 * given a decimal number, print the corresponding hexadecimal number
 * inputs:
 *   unsigned int number - a decimal number
 * output:
 *   prints out, but does not return, the hexacimal number
 */
void print_hex(unsigned int number)
{
    if ((number / 16) < 1)
        printf("%x", (number % 16));
    else
    {
        print_hex(number / 16);
        printf("%x", (number % 16));
    }
}

/* print_asterisk_word
 * given a letter, print the corresponding upper-case word in sterisks
 * inputs:
 *   char[] - a character array
 *   unsigned int length - the number of letters in the character array
 * output:
 *   prints out, but does not return, the word in the array
 */
void print_asterisk_word(char word[], unsigned int length)
{
    char R[5][5] = {{'*', '*', '*', ' ', ' '},
                    {'*', ' ', ' ', '*', ' '},
                    {'*', '*', '*', ' ', ' '},
                    {'*', ' ', '*', ' ', ' '},
                    {'*', ' ', ' ', '*', ' '}};
    char S[5][5] = {{' ', '*', '*', '*', ' '},
                    {'*', ' ', ' ', ' ', ' '},
                    {' ', '*', '*', ' ', ' '},
                    {' ', ' ', ' ', '*', ' '},
                    {'*', '*', '*', ' ', ' '}};
    char T[5][6] = {{'*', '*', '*', '*', '*', ' '},
                    {' ', ' ', '*', ' ', ' ', ' '},
                    {' ', ' ', '*', ' ', ' ', ' '},
                    {' ', ' ', '*', ' ', ' ', ' '},
                    {' ', ' ', '*', ' ', ' ', ' '}};
    char U[5][6] = {{'*', ' ', ' ', ' ', '*', ' '},
                    {'*', ' ', ' ', ' ', '*', ' '},
                    {'*', ' ', ' ', ' ', '*', ' '},
                    {'*', ' ', ' ', ' ', '*', ' '},
                    {' ', '*', '*', '*', ' ', ' '}};
    int i, j;
    for (i = 0; i < 5; i++)
    {
        for (j = 0; j < length; j++)
        {
            switch (word[j])
            {
                case 'r':
                    printf("%.*s", 5, R[i]);
                    break;
                case 't':
                    printf("%.*s", 6, T[i]);
                    break;
                case 'u':
                    printf("%.*s", 6, U[i]);
                    break;
                case 's':
                    printf("%.*s", 5, S[i]);
                    break;
                default:
                    break;
            }
        }
        printf("\n");
    }
}

/* print_asterisk_shape
 * given a height between 1 and 40, print a shape composed of two symmetrical isoceles triangles
 * with their edges facing outwards, a square, and two symmetrical isoceles triangles
 * with their edges touching
 * inputs:
 *   unsigned int h - the side length/height
 * output:
 *   prints out, but does not return, the shape
 */
void print_asterisk_shape(unsigned int h)
{
    if ((h < 41) && (h > 0))
    {
        int i, j;
        for (i = 1; i <= h; i++)
        {
            for (j = 0; j < (2 * h); j++)
            {
                if ((j < i) || (((2 * h) - j) <= i))
                    printf("*");
                else
                {
                    printf(" ");
                }
            }
            printf("\n");
        }
        for (i = 0; i < h; i++)
        {
            for (j = 0; j < (2 * h); j++)
                printf("*");
            printf("\n");
        }
        for (i = 0; i < h; i++)
        {
            for (j = 0; j < (2 * h); j++)
            {
                if ((j < i) || (((2 * h) - j) <= i))
                    printf(" ");
                else
                {
                    printf("*");
                }
            }
            printf("\n");
        }
    }
    else
    {
        fprintf(stderr, "error (print_asterisk_shape): number not in range\n");
    }
}

/* sort
 * given an array and a destination array
 * sorts the given one into the destination array
 * with helper function insert_into_array
 * inputs:
 *   source_array[] - an integer array
 *   dest_array[] - an integer array
 *   size - the size of the array
 * output:
 *   sorts the source array into the dest array and prints the dest array out
 */

void insert_into_array(int array[], unsigned int cur_size,
			unsigned int total_size, int value)
{
    int i = 0;
    int j;
    if (cur_size >= total_size)
        return;
    else if (cur_size < 1)
        array[0] = value;
    else
    {
        while (value > array[i])
            i++;
        for ((j = (cur_size - 1)); (i <= j); j--)
            array[j + 1] = array[j];
        array[i] = value;
    }
}

void sort(int source_array[], int dest_array[], unsigned int size)
{
    int i, j;
    for (i = 0; i < size; i++)
        insert_into_array(dest_array, i, size, source_array[i]);
    for (j = 0; j < size; j++)
        printf("%d ", dest_array[j]);
}