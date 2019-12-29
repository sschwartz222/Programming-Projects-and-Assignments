#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "word.h"
#include "hash.h"
#define MAX_BUFFER 150


void do_full_test(char *filename, int table_size);
float insert_search_from_file(hash_table_t *ht, char * filename);
int printed_insert(hash_table_t* ht, void *value);
int printed_search(hash_table_t* ht, void *value);
void print_hash_table_entries(hash_table_t *ht);

int main(int argc, char* argv[])
{
    //Uncomment the following to test your code: 

    
    hash_table_t* ht1 = create_hash_table(10, CHAINED, get_key, compare_words);

    printf("Insertion and Search Example\n==================\n");
    wordcount *wc = create_count("uchicago");
    printf("created word count\n");
    printed_insert(ht1, (void *)wc);
    print_hash_table_entries(ht1);
    printf("start searching\n");
    printed_search(ht1, (void*)wc);
    
    
    //Uncomment the following line to do full tests, provide filename and hash_table size as arguments:
    do_full_test(argv[1], atoi(argv[2]));

    return 0;
}


void do_full_test(char *filename, int table_size)
{
    FILE *f = fopen("file.txt", "w");
        if (f == NULL)
        {
            printf("Error opening file!\n");
            exit(1);
        }
    for(int type=0; type < 3; type++)
    {
        char *type_to_string[] = {"Linear", "Quadratic", "Chained"};
        
        hash_table_t* ht = create_hash_table(table_size, type, get_key, compare_words);

        fprintf(f, "=====================================================================\n");
        fprintf(f, "%s Test, Filename: %s, Hash Table Size: %d\n", type_to_string[type], filename, table_size);
        fprintf(f, "=====================================================================\n");
        float average_ops = insert_search_from_file(ht, filename);
        // float average_search = search_from_file(ht, filename);
        fprintf(f, "---------------------------------------------------------------------\n");
        fprintf(f, "%s Average # of Operations: %f\n", type_to_string[type], average_ops);
        // printf("%s Average Search Operations: %f\n", type_to_string[type], average_search);
        fprintf(f, "---------------------------------------------------------------------\n\n");
    }
}




float insert_search_from_file(hash_table_t *ht, char * filename)
{
    FILE *fp;
    char buf[MAX_BUFFER] = "";
    int count=0, total=0;

    // attempt to open the file, then check whether that worked.
    if ((fp = fopen(filename, "r")) == NULL)
    {
        fprintf(stderr,"Could not open file %s\n",filename);
        return (1);
    }

    char* op, *word;
    while (fgets(buf, sizeof(buf), fp) != NULL)
    {
        buf[strlen(buf)-1] = '\0';
        op = strtok(buf, " \n");
        word = strtok(NULL, " \n");
        wordcount *wc = create_count(word);
        if (strcmp(op, "insert") == 0)
            total += printed_insert(ht, (void *)wc);
        else if (strcmp(op, "search") == 0)
            total += printed_search(ht, (void *)wc);
        else{
            printf("operation %s not supported\n", op);
        }
        count++;
    }

    fclose(fp);

    return (float) total/count;
}

int printed_insert(hash_table_t* ht, void *value)
{
    int opcount = 0;
    insert(ht, value, &opcount);
    printf("Inserted (%lu,",ht->getkey(value));
    print_word(value);
    printf("), Opcount: %d\n", opcount);

    return opcount;
}

int printed_search(hash_table_t* ht, void *value)
{
    int opcount = 0;
    hash_node_t *search_node = search(ht, value, &opcount);
    printf("Searched value (%lu,",ht->getkey(value));
    print_word(value);
    printf("), Opcount: %d ", opcount);
    if(search_node)
        printf("Found\n");
    else
        printf(" Not Found\n");

    return opcount;
}



void print_hash_table_entries(hash_table_t *ht)
{
    int i;
    // printf("start printing hash table\n");
    for(i=0; i < ht->size; i++)
    {
        // printf("print bucket %d\n", i);
        hash_node_t *ptr = ht->head[i];
        //printf("%p\n", ptr);
        // print the first one
        if (ptr != NULL)
        {
            //printf("case not null\n");
            printf("[%d]= (%lu,", i ,ptr->key);
            //printf("\n");
            print_word(ptr->value); // yes, breaking abstraction
            //printf("\n");
            printf(") ");
            ptr=ptr->next;
        } else
        {
            //printf("case null\n");
            printf("[%d]= NULL ", i);
        }
        // print the rest
        while(ptr!=NULL)
        {
            //printf("%p\n", ptr);
            printf(" -> (%lu,", ptr->key);
            //printf("\n");
            print_word(ptr->value); // yes, breaking abstraction
            printf(") ");
            ptr=ptr->next;
        }
        printf("\n");
    }
}