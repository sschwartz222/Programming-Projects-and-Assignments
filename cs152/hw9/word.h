#ifndef WORD_H
#define WORD_H

/* This file contains the structs and functions for 
 * wordcount. This stores a word and a count of how many
 * times it has been seen. It includes a constructor (create_count),
 * an accessor (get_count), a
 * print function (print_word), and two comparison functions
 * so that it can be stored in a sorted data structure sorted 
 * either by word or by count.
 */ 

typedef struct {
	int count;
	char word[100];
} wordcount;

/* create_count
 * word - the word to store
 * allocates space for a wordcount. Copies the word and
 * initializes count to 0.
 */
wordcount *create_count(char *word);

/* This frees the wordcount struct */
void free_count(wordcount *wc);

/* get_count
 * returns the count field of the wordcount struct v points to.
 */
int get_count(void *v);

/* print_word
 * prints the wordcount struct pointed to by v.
 */
void print_word(void* v);

/* compare_words
 * compares two wordcount structs. It compares by comparing
 * the words being stored. The order is the same order as in strcmp.
 * It returns -1 if v1 < v2, 0 if v1 == v2, and 1 if v1 > v2 as defined
 * by alphabetical order.
 */
int compare_words(void *v1, void *v2);

/* get_key
 * transforms the word into an integer key
 */
unsigned long int get_key(void *v);

#endif
