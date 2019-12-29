#define __USE_XOPEN
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <time.h>
#include "hw4_provided.h"
#include "hw4.h"

// FOR SOME REASON, WHEN I TEST USING TESTSCRIPT, THE FUNCTIONS DONT
// WORK PROPERLY; THUS, I'VE INCLUDED MY OWN TESTS, COMMENTED OUT BELOW,
// IN THE USUAL STYLE.
int main(int argc, char *argv[])
{
  char filename[] = "data.csv";
  struct tm first_day;
  int num_days, num_records_per_day;
  // read data from the csv file
  record*** rs = read_spotify_data(filename, 
      &num_days, &num_records_per_day, &first_day);
  printf("read data of %d days, and %d records per day. \n", 
      num_days, num_records_per_day);
  if(argc == 0)
    printf("not enough arguments\n");
  else
  {
    switch (atoi(argv[1]))
    {
      case 0:
      {
        if (argc == 3)
          find_highest_record_by_date(argv[2], rs, num_days);
        else
          printf("Invalid number of arguments!");
        printf("\n");
        break;
      }
      case 1:
      {
        if (argc == 3)
          find_artist_highest_rank(argv[2], rs, num_days, num_records_per_day);
        else
          printf("Invalid number of arguments!");
        printf("\n");
        break;
      }
      case 2:
      {
        if (argc == 4)
        {
          double score = score_artist(argv[3], rs, num_days, 
                                      num_records_per_day);
          if ((score <= 0.01 + atof(argv[2])) && 
              (score >= atof(argv[2]) - 0.01))
            printf("%f - PASSED", score);
          else
            printf("Expected %f, actually %f, - FAILED", atof(argv[2]), score);
        }
        else
          printf("Invalid number of arguments!");
        printf("\n");
        break;
      }
      case 3:
      {
        if (argc == 4)
        {
          double score = score_song(argv[3], rs, num_days,
                              num_records_per_day);
          if ((score <= 0.01 + atof(argv[2])) && 
              (score >= atof(argv[2]) - 0.01))
            printf("%f - PASSED", score);
          else
            printf("Expected %f, actually %f, - FAILED", atof(argv[2]), score);
        }
        else
          printf("Invalid number of arguments!");
        printf("\n");
        break;
      }
      default:
      {
        printf("Invalid function choice!\n");
      }
    }
  }
  //find_artist_highest_rank("Bruno Mars", rs, num_days, num_records_per_day);
  //printf("%f\n", score_artist("Bruno Mars", rs, num_days, 
  //                             num_records_per_day));

    //previous old tests
    /*find_highest_record_by_date("2017-04-07", rs, num_days);
    printf("\n");
    find_highest_record_by_date("2016-04-07", rs, num_days);
    printf("\n");
    find_artist_highest_rank("Bruno Mars", rs, num_days, num_records_per_day);
    printf("\n");
    find_artist_highest_rank("Bruno Marss", rs, num_days, num_records_per_day);
    printf("\n");
    printf("%f\n", score_artist("Bruno Mars", rs, num_days, 
                                  num_records_per_day));
    printf("%f\n", score_artist("Bruno Marss", rs, num_days, 
                                  num_records_per_day));
    printf("%f\n", score_artist("Cardi B", rs, num_days, 
                                  num_records_per_day));
    printf("%f\n", score_song("Havana", rs, num_days, num_records_per_day));
    printf("%f\n", score_song("Havanas", rs, num_days, num_records_per_day));
    printf("%f\n", score_song("Despacito - Remix", rs, num_days, 
                                num_records_per_day));*/


  /*// print the data
  for (int i = 0; i < num_days; ++i){
    for (int j = 0; j < num_records_per_day; ++j){
      if (rs[i][j] == NULL){
        printf("data of day %d and rank %d does not exist\n", i+1, j+1);
      } else {
        print_record(rs[i][j]);    
      }
    }
  }*/

  // free memories
  free_records(rs, num_days, num_records_per_day);
  return 0;
}