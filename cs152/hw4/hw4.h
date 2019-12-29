#ifndef HW4_H
#define HW4_H

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "hw4_provided.h"

/* find_highest_record_by_date
* finds the rank 1 record on a date and prints and returns it
* inputs:
*   const char* date - date string
*   record*** rs - data as read by provided function
*   num_days - number of days in data set as read by provided function
* outputs:
*   prints and returns rank 1 record of a date
*/
record* find_highest_record_by_date(const char* date, record*** rs, 
                                    int num_days);

/* find_artist_highest_rank
* finds the artist's highest ranking record and prints and returns it
* inputs:
*   const char* date - artist string
*   record*** rs - data as read by provided function
*   num_days - number of days in data set as read by provided function
*   num_records_per_day - number of records per day in data set as read by
*                           provided function
* outputs:
*   prints and returns highest ranked record of an artist
*/
record* find_artist_highest_rank(const char* artist, record*** rs, 
                                    int num_days, int num_records_per_day);

/* score_artist
* finds an artist's score
* inputs:
*   const char* date - artist string
*   record*** rs - data as read by provided function
*   num_days - number of days in data set as read by provided function
*   num_records_per_day - number of records per day in data set as read by
*                           provided function
* outputs:
*   returns score as a double
*/
double score_artist(const char* artist, record*** rs, 
                    int num_days, int num_records_per_day);

/* score_song
* finds a song's score
* inputs:
*   const char* date - artist string
*   record*** rs - data as read by provided function
*   num_days - number of days in data set as read by provided function
*   num_records_per_day - number of records per day in data set as read by
*                           provided function
* outputs:
*   returns score as a double
*/
double score_song(const char* song, record*** rs, 
                    int num_days, int num_records_per_day);

#endif