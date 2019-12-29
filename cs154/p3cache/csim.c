#include "cachelab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#define BUFFER_SIZE 300
//put lru val into access count then increment lru
typedef struct {
    int valid;
    unsigned long long int tag;
    int lru_counter;
} cacheline;

cacheline*** create_cache(int s, int e){
    //cacheline** cs = (cacheline**)malloc(e*sizeof(cacheline*));
    cacheline*** cl = (cacheline***)malloc((1<<s)*(sizeof(cacheline**)));
    if (cl == NULL){
        fprintf(stderr, "malloc unsuccessful");
        exit(-1);
    }
    int i, j;
    for (i = 0; i < (1<<s); i++){
        //for (j = 0; j < e; j++){
        cl[i] = (cacheline**)malloc(e*(sizeof(cacheline*)));
    }
    for (i = 0; i < (1<<s); i++){
        for (j = 0; j < e; j++){
            cl[i][j] = NULL;
        }
    }
    return cl;
}

void insert_line(cacheline* c, cacheline*** cache, int i, int j){
    cache[i][j] = c;
}

int bitMask(int highbit, int lowbit) {
  int mask = ~0;
  return (~((mask << (highbit)) ^ (1 << highbit)) & (mask << lowbit));
}

void parse_bits(long long addr, int s, int b, int *bbits, int *sbits, unsigned long long int *tbits){
    //fprintf(stderr, "address: %llx\n", addr);
    int x = addr & (bitMask(b-1, 0));
    int y = ((addr & (bitMask(s+b-1, b))) >> b);
    unsigned long long int z = addr & (bitMask(63, s+b));
    //fprintf(stderr, "parsed bits: %d, %d, %llu\n", x, y, z);
    *bbits = x;
    *sbits = y;
    *tbits = z;
}

void print_cacheline(cacheline* c){
    fprintf(stderr, "%d, %llu, %d\n", c->valid, c->tag, c->lru_counter);
}

cacheline* make_cacheline(unsigned long long int tag, int lru){
    cacheline *cl = (cacheline*)malloc(sizeof(cacheline));
    const cacheline cacheline_init = {1, tag, lru};
    *cl = cacheline_init;
    return cl;
}

long long hextodec(const char* hex){;
    long long dec;
    int i = 0;
    int v, l;
    dec = 0;
    l = strlen(hex);
    l--;
    for(i = 0; hex[i] != '\0'; i++)
    {
        if(hex[i] >= '0' && hex[i] <= '9')
            v = hex[i] - 48;
        else if((hex[i] >= 'a') && (hex[i] <= 'f'))
            v = hex[i] - 97 + 10;
        dec += v*pow(16, l);
        l--;
    }
    return dec;
}

void simulate(char* filename, int s, int e, int b, cacheline*** cache, int* hs, int* ms, int* es){
    FILE* fp = fopen(filename, "r");
    if (fp == NULL){
        fprintf(stderr, "file %s does not exist", filename);
        exit(-1);
    }
    else{
        char line[BUFFER_SIZE];
        int i, access;
        long long address;
        const char* tok;
        int hit = 0;
        int miss = 0;
        int eviction = 0;
        int counter = 0;
        while ((fgets(line, BUFFER_SIZE, fp)) != NULL){
            //fprintf(stderr, "\n================\n%s", line);
            const char first = line[0];
            //fprintf(stderr, "%c, %c\n", line[0], first);
            if (strcmp(&first, "I") == 0)
                continue;
            if (first == 'I') continue;
            else
            {
                for (i = 0, tok = strtok(line, " ,"); 
                i < 2; tok = strtok(NULL, " ,\n"), i++)
                {
                    if (i == 0)
                    {
                        if (strcmp(tok, "M") == 0)
                            access = 0;
                        else if (strcmp(tok, "L") == 0)
                            access = 1;
                        else
                            access = 2;
                    }
                    else
                    {
                        address = hextodec(tok);
                    }
                }
            }
            int *bbits = (int*)malloc(sizeof(int));
            int *sbits = (int*)malloc(sizeof(int));
            unsigned long long int *tbits = (unsigned long long int*)malloc(sizeof(unsigned long long int));
            int lru = 1000000;
            int lru_spot = 0;
            counter++;
            parse_bits(address, s, b, bbits, sbits, tbits);
            cacheline* cl =make_cacheline(*tbits, counter);
            if (access == 0)
                hit++;
            //fprintf(stderr, "*sbits: %d\n", *sbits);
            int pass = 1;
            for (i = 0; i < e; i++)
            {
                if (cache[*sbits][i] == NULL)
                {
                    //fprintf(stderr, "cache null, inserting line: ");
                    //print_cacheline(cl);
                    insert_line(cl, cache, *sbits, i);
                    miss++;
                    pass = 0;
                    break;
                }
                else if ((cache[*sbits][i]->valid == 1) && (cache[*sbits][i]->tag == cl->tag))
                {
                    //fprintf(stderr, "cache hit, line is: ");
                    //print_cacheline(cl);
                    hit++;
                    cache[*sbits][i]->lru_counter = counter;
                    pass = 0;
                    break;
                }
            }
            if (pass == 0)
                continue;
            else
            {
                //fprintf(stderr, "hello\n");
                miss++;
                eviction++;
                for (i = 0; i < e; i++)
                {
                    if (cache[*sbits][i]->lru_counter < lru)
                    {
                        lru = cache[*sbits][i]->lru_counter;
                        lru_spot = i;
                    }
                }
                //fprintf(stderr, "cache eviction, inserting line: ");
                //print_cacheline(cl);
                insert_line(cl, cache, *sbits, lru_spot);
            }
        }
        *hs = hit;
        *ms = miss;
        *es = eviction;
    }
}    

int main(int argc, char **argv)
{
    int hits = 0;
    int misses = 0;
    int evictions = 0;
    int *hs;
    int *ms;
    int *es;
    hs = &hits;
    ms = &misses;
    es = &evictions;
    int s = 0;
    int e = 0;
    int b = 0;
    char *fp = NULL;
    //int c;
    int i;
    for (i = 0; argv[i] != NULL; i++)
    {
        if (strcmp(argv[i], "-s") == 0)
        {
            s = atoi(argv[i+1]);
            continue;
        }
        else if (strcmp(argv[i], "-E") == 0)
        {
            e = atoi(argv[i+1]);
            continue;
        }
        else if (strcmp(argv[i], "-b") == 0)
        {
            b = atoi(argv[i+1]);
            continue;
        }
        else if (strcmp(argv[i], "-t") == 0)
        {
            fp = argv[i+1];
            continue;
        }
    }
    /*while ((c = getopt(argc, argv, "hvsEbt")) != 0)
    {
        switch (c)
        {
            case 's':
                s = atoi(optarg);
                break;
            case 'E':
                e = atoi(optarg);
                break;
            case 'b':
                b = atoi(optarg);
                break;
            case 't':
                fp = optarg;
                break;
        }
    }*/
    cacheline*** cache = create_cache(s, e);
    simulate(fp, s, e, b, cache, hs, ms, es); 
    printSummary(*hs, *ms, *es);
    return 0;
}


