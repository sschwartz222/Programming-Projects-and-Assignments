#include <stdio.h>
#include <stdlib.h>
#include "warmup4_provided.h"
#include "warmup4.h"
 

int main(int argc, char *argv[])
{
    int i;
    int total = 0;
    pixel color;
    if(argv == NULL)
        printf("argv pointer is null\n");
    else
    {
        switch (atoi(argv[1]))
        {
            case 0:
                if (argc > 3)
                {
                    for(i = 3; i < argc; i++)                       
                        total += count_vowels(argv[i]);
                    if (total == atoi(argv[2]))
                        printf("%d - PASSED\n", total);
                    else   
                    {
                        printf("Expected %d, actually %d - FAILED\n",
                                atoi(argv[2]), total);
                    }
                    break;                    
                }
                else
                {
                    printf("Too few arguments!\n");
                    break;
                }
            case 1:
                if (argc > 2)
                {
                    for(i = 2; i < argc; i++)
                    {
                        make_lowercase(argv[i]);
                        printf("%s ", argv[i]);
                    }
                    printf("\n");
                    break;
                }
                else
                {
                    printf("Too few arguments!\n");
                    break;
                }
            case 2:
                if (argc == 8)
                {
                    color.red = atoi(argv[4]);
                    color.green = atoi(argv[5]);
                    color.blue = atoi(argv[6]);
                    pixel **image = make_and_init_image(atoi(argv[2]), 
                                                        atoi(argv[3]), color);
                    provided_write_png_struct(argv[7], image, 
                                                atoi(argv[3]), atoi(argv[2]));
                    break;
                }
                else
                {
                    printf("Invalid number of arguments!\n");
                    break;
                }
            default:
                printf("invalid function number provided!\n");
        }
    }

    // my own previous tests
    /*char str1[] = "YIPPEE!";
    char str2[] = "YiPpEe!";
    char str3[] = "yippee!";
    char str4[] = "yippee";
    char str5[] = "";
    pixel testimage1;
    testimage1.red = 255;
    testimage1.green = 0;
    testimage1.blue = 0;
    printf("%d\n", count_vowels(str1));
    printf("%d\n", count_vowels("aeiouaeiouaeiou"));
    printf("%d\n", count_vowels(""));
    printf("%d\n", count_vowels(str2));
    make_lowercase(str1);
    make_lowercase(str2);
    make_lowercase(str3);
    make_lowercase(str4);
    make_lowercase(str5);
    printf("%s\n", str1);
    printf("%s\n", str2);
    printf("%s\n", str3);
    printf("%s\n", str4);
    printf("%s\n", str5);
    pixel **test1 = make_and_init_image(1000, 1500, testimage1);
    provided_write_png_struct("test1.png", test1, 1500, 1000);*/
}