#ifndef HW4_PROVIDED_H
#define HW4_PROVIDED_H

#define BUFFER_SIZE 1024

// a single line of spotify record
typedef struct {
  int position;
  char* song;
  char* artist;
  struct tm* date;
} record;

extern int Julian_A[12];
extern int Julian_M[12];

/* convert a date to an integer 
 * so that the difference between julian_day will be the difference of days
 * between two dates. 
 */
int julian_day(struct tm *date);

/* Read a single record from a line of character array
 * inputs:
 *   char* line - a line from the spotify top ranked songs
 * output:
 *   record* - a record pointer created by the line of song
 */
record* read_record(char* line);

/* print all information in a record
*/
void print_record(record* r);

/* initialize the 2d array of record pointers
 * inputs:
 *   int num_days - number of days
 *   int num_records_per_day - number of records per day
 * outputs:
 *   record*** - a 2d array of shape (num_days,, num_records_per_day) 
 *     of record pointers (record*)
 */
record*** initialize_record_2d_array(int num_days, int num_records_per_day);


/* insert a record into the 2d array of records
 * inputs:
 *   record* r - the record to be inserted
 *   record*** rs - the 2d array to store record pointers
 *   int num_days - number of days
 *   int num_records_per_day - number of records for each day
 *   struct tm* first_day - the first day of records
 */
void insert_record(record* r, record*** rs, int num_days, int num_records_per_day,
    struct tm* first_day);

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
    int* num_days, int* num_records_per_day, struct tm* first_day);

/* free all memories of records
 * inputs:
 *   record*** rs - the 2d record array to be freed
 *   int length - length of the first dimension
 *   int width - width of the second dimension
 * outputs: 
 *   void
 */
void free_records(record*** rs, int length, int width);

#endif