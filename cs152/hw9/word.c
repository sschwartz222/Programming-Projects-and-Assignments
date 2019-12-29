#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "word.h"

/* create_count
 * creates a wordcount struct, copies the word to its memory,
 * and initializes the count to 1.
 */
wordcount *create_count(char *word)
{
	wordcount *wc = (wordcount*)malloc(sizeof(wordcount));
    wc->count = 1;
    strcpy(wc->word, word);
    return wc;
}

/* This frees struct wordcount */
void free_count(wordcount *wc)
{
	free(wc);
}

/* get_count
 * this function is provided to test your accumulator function
 * for your BST.
 * This returns the count in a particular word.
 */
int get_count(void *v)
{
	if (v != NULL)
        return ((wordcount*)v)->count;
    else
        return -1;
}

/* print_word
 * print function that prints the contents of a single countword struct
 */
void print_word(void* v)
{
	if (v != NULL)
        printf("%s", ((wordcount*)v)->word);
}

/* compare_words
 * This function compares two wordcount structs. It compares by comparing
 * the words being stored. The order is the same order as in strcmp.
 * It returns -1 if v1 < v2, 0 if v1 == v2, and 1 if v1 > v2 as defined
 * by alphabetical order.
 */
int compare_words(void *v1, void *v2)
{
	if ((v1 == NULL) || (v2 == NULL))
        return 2;
    else
    {
        int result = strcmp(((wordcount*)v1)->word, ((wordcount*)v2)->word);
        return result;
    }
}


/* get_key
 * transforms the word into an integer key
 */
unsigned long int get_key(void *v){
	unsigned long res = 17;
    if (v == NULL)
        return 0;
    else
    {
        unsigned int len = strlen(((wordcount*)v)->word);
        int i;
        for (i = 0; i < len; i++)
            res = 37*res + ((((wordcount*)v)->word)[i]);
        return res;
    }
}

