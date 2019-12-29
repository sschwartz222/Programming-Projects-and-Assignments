#define __USE_XOPEN
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "hw4_provided.h"


int Julian_A[12] = { 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int Julian_M[12] = { 10, 11, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };

/* convert a date to an integer 
 * so that the difference between julian_day will be the difference of days
 * between two dates. 
 */
int julian_day(struct tm *date){
  int a = Julian_A[date->tm_mon];
  int m = Julian_M[date->tm_mon];
  int y = date->tm_year + 1900 + 4800 - a;
  return date->tm_mday + ((153*m + 2) / 5) + 365*y + y/4 - y/100 + y/400 - 32045;
}

/* Read a single record from a line of character array
 * inputs:
 *   char* line - a line from the spotify top ranked songs
 * output:
 *   record* - a record pointer created by the line of song
 */
record* read_record(char* line) {
  record* r = (record*)malloc(sizeof(record));
  const char* tok;
  int i;
  for (i = 0, tok = strtok(line, ","); 
      tok && *tok && i < 6; 
      tok = strtok(NULL, ",\n"), i++){
    if (i == 0){
      r->position = atoi(tok);
    } else if (i == 1) {
      r->song= strdup(tok);
    } else if (i == 2) {
      r->artist = strdup(tok);
    } else if (i == 5){
      r->date = malloc(sizeof(struct tm));
      strptime(tok, "%F", r->date);
      return r;
    }
  }
  return NULL;
}

/* print all information in a record
 */
void print_record(record* r){
  char str_date[256];
  strftime(str_date, sizeof(str_date), "%F", r->date);
  printf("%d, %s, %s, %s\n", r->position, r->song, r->artist, str_date);
}

/* initialize the 2d array of record pointers
 * inputs:
 *   int num_days - number of days
 *   int num_records_per_day - number of records per day
 * outputs:
 *   record*** - a 2d array of shape (num_days,, num_records_per_day) 
 *     of record pointers (record*)
 */
record*** initialize_record_2d_array(int num_days, int num_records_per_day){
  record*** rs = (record***)malloc(num_days*sizeof(record**));
  if (rs == NULL){
    fprintf(stderr, "malloc unsuccessful");
    exit(-1);
  }
  int i, j;
  for (i = 0; i < num_days; ++i){
    rs[i] = (record**)malloc(num_records_per_day*sizeof(record*));
    if (rs[i] == NULL){
      fprintf(stderr, "malloc unsuccessful");
      exit(-1);
    }
    for (j = 0; j < num_records_per_day; ++j)
      rs[i][j] = NULL;
  }
  return rs;
}

/* insert a record into the 2d array of records
 * inputs:
 *   record* r - the record to be inserted
 *   record*** rs - the 2d array to store record pointers
 *   int num_days - number of days
 *   int num_records_per_day - number of records for each day
 *   struct tm* first_day - the first day of records
 */
void insert_record(record* r, record*** rs, int num_days, int num_records_per_day,
    struct tm* first_day){
  int daydiff = 0; // date difference variable to be used for index computation
  daydiff = julian_day(r->date) - julian_day(first_day);
  if (daydiff < num_days && daydiff >= 0 && r->position <= num_records_per_day
      && r->position > 0)
    rs[daydiff][r->position - 1] = r;
}

/* read spotify rank data into a 2 dimensional array
 * the first dimension represents the date
 * the second dimension represents the rank of the song
 * inputs:
 *   char* filename - the file to read the data
 *   int* num_days - out parameter, number of days to read
 *   int* num_records_per_day - out parameter, number of records each day
 *   struct tm* first_day - out parameter, the first day to read
 */
record*** read_spotify_data(char* filename, 
    int* num_days, int* num_records_per_day, struct tm* first_day){
  FILE* fp = fopen(filename, "r");
  if (fp == NULL){
    fprintf(stderr, "file %s does not exist, please download from the course website", filename);
    exit(-1);
  }

  char line[BUFFER_SIZE];
  char* s = fgets(line, BUFFER_SIZE, fp);
  if (s == NULL){
    fprintf(stderr, "failed reading first line of %s\n", filename);
    exit(-1);
  }
  const char* tok = strtok(line, ",");
  if (tok == NULL){
    fprintf(stderr, "failed reading first date\n");
    exit(-1);
  }
  s = strptime(tok, "%F", first_day);
  if (s == NULL){
    fprintf(stderr, "cannot convert date %s\n", tok);
    exit(-1);
  }
  tok = strtok(NULL, ",\n");
  if (tok == NULL){
    fprintf(stderr, "failed reading number of days\n");
    exit(-1);
  }
  *num_days = atoi(tok);
  tok = strtok(NULL, ",\n");
  if (tok == NULL){
    fprintf(stderr, "failed reading number of records per day\n");
    exit(-1);
  }
  *num_records_per_day = atoi(tok);

  // initialize the 2d array of records 
  record*** rs = initialize_record_2d_array(*num_days, *num_records_per_day);

  char* tmp;
  record* tmp_r;
  while (fgets(line, BUFFER_SIZE, fp)){
    tmp = strdup(line);
    tmp_r = read_record(tmp);  
    if (tmp_r == NULL){
      fprintf(stderr, "error reading line: %s\n", tmp);
      continue;
    }
    insert_record(tmp_r, rs, *num_days, *num_records_per_day, first_day);
    free(tmp);
  }
  return rs;
}

/* free all memories of records
 * inputs:
 *   record*** rs - the 2d record array to be freed
 *   int length - length of the first dimension
 *   int width - width of the second dimension
 * outputs: 
 *   void
 */
void free_records(record*** rs, int length, int width){
  for (int i = 0; i < length; ++i){
    for (int j = 0; j < width; ++j){
      if (rs[i][j] == NULL) continue; 
      free(rs[i][j]->song);
      free(rs[i][j]->artist);
      free(rs[i][j]->date);
      free(rs[i][j]);
    }
    free(rs[i]);
  }
  free(rs);
}