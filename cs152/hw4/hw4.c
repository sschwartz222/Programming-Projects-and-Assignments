#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "hw4.h"
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
                                    int num_days)
{
    int i;
    struct tm *datetm = (struct tm *) malloc(sizeof(struct tm));
    strptime(date, "%F", datetm);
    int dateint = julian_day(datetm);
    for (i = 0; i < num_days; i++)
    {
        if ((rs[i][0] == NULL) || (rs[i][0]->date == NULL))
        {
            printf("record pointer is null "
                   "or date value is null "
                   "for day %d, rank 1\n", i+1);
        }
        else if ((julian_day(rs[i][0]->date)) == dateint)
        {
            print_record(rs[i][0]);
            return (rs[i][0]);
        }
    }
    printf("ERROR: no value found\n");
    return NULL;
}

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
                                    int num_days, int num_records_per_day)
{
    int i, j;
    record *highrank = (record *) malloc(sizeof(record));
    highrank->position = (num_records_per_day + 1);
    for (i = 0; i < num_days; i++)
    {
        for (j = 0; j < num_records_per_day; j++)
        {
            if ((rs[i][j] == NULL) || (rs[i][j]->artist == NULL) 
                || (rs[i][j]->position == NULL))
            {
                printf("ERROR: record pointer is null "
                       "or artist or position value is null "
                       "for day %d, rank %d\n", i+1, j+1);
            }
            else if ((strcmp(artist, rs[i][j]->artist)) == 0)
            {
                if ((rs[i][j]->position) < (highrank->position))
                    highrank = rs[i][j];
            }
        }    
    }
    if ((highrank->position) < (num_records_per_day + 1))
    {
        print_record(highrank);
        return highrank;
    }
    else
    {
        printf("ERROR: find_artist_highest_rank artist not found\n");
        return NULL;
    }    
}

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
                    int num_days, int num_records_per_day)
{
    int points[20] = {50, 40, 30, 20, 16, 15, 14, 13, 12, 11, 10,
                        9, 8, 7, 6, 5, 4, 3, 2, 1};
    int i, j;
    double totalpoints = 0;
    for (i = 0; i < num_days; i++)
    {
        for (j = 0; j < num_records_per_day; j++)
        {
            if ((rs[i][j] == NULL) || (rs[i][j]->position == NULL) 
                || (rs[i][j]->artist == NULL))
            {
                printf("ERROR: record pointer is null "
                       "or position or artist value is null "
                       "for day %d, rank %d\n", i+1, j+1);
            }
            else if ((strcmp(artist, rs[i][j]->artist)) == 0)
            {
                totalpoints += points[(rs[i][j]->position) - 1];
            }    
        }
    }
    return totalpoints;
}

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
                    int num_days, int num_records_per_day)
{
    int points[20] = {50, 40, 30, 20, 16, 15, 14, 13, 12, 11, 10,
                        9, 8, 7, 6, 5, 4, 3, 2, 1};
    int i, j;
    double totalpoints = 0;
    for (i = 0; i < num_days; i++)
    {
        for (j = 0; j < num_records_per_day; j++)
        {
            if ((rs[i][j] == NULL) || (rs[i][j]->position == NULL) 
                || (rs[i][j]->song == NULL))
            {
                printf("ERROR: record pointer is null "
                       "or position or song value is null "
                       "for day %d, rank %d\n", i+1, j+1);
            }
            else if ((strcmp(song, rs[i][j]->song)) == 0)
                totalpoints += points[(rs[i][j]->position) - 1];
        }
    }
    return totalpoints;
}

