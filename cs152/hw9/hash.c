#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "hash.h"

unsigned int generate_hash(hash_table_t *ht, unsigned long int key) 
{
    if (ht != NULL)
    {
        unsigned int hash = key % (ht->size);
        return hash;
    }
    else
        return -1;
}

hash_table_t* create_hash_table(unsigned int size, enum table_type type, 
                                unsigned long int (*getkey)(void *), 
                                int (*compare)(void *, void *))
{
    hash_table_t *ht = (hash_table_t*)malloc(sizeof(hash_table_t));
    ht->ttype = type;
    ht->size = size;
    ht->head = (hash_node_t**)malloc(size*(sizeof(hash_node_t*)));
    int i;
    for (i = 0; i < size; i++)
        (ht->head)[i] = NULL;
    ht->getkey = getkey;
    ht->compare = compare;
    return ht;
}


int insert(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        int res;
        switch(ht->ttype)
        {
            case LINEAR :
                res = insert_linear(ht, value, opcount);
                return res;
            case QUADRATIC :
                res = insert_quadratic(ht, value, opcount);
                return res;
            case CHAINED :
                res = insert_chained(ht, value, opcount);
                return res;
        }
    }
    else
        return 0;
}


hash_node_t* search(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        hash_node_t* res;
        switch(ht->ttype)
        {
            case LINEAR :
                res = search_linear(ht, value, opcount);
                return res;
            case QUADRATIC :
                res = search_quadratic(ht, value, opcount);
                return res;
            case CHAINED :
                res = search_chained(ht, value, opcount);
                return res;
        }
    }
    else
        return NULL;
}

hash_node_t* insert_head(hash_node_t* head, hash_node_t* insert)
{
    if (head == NULL)
    {   
        insert->next = NULL;
        return insert;
    }
    else if (insert == NULL)
        return head;
    else
    {
        insert->next = head;
        return insert;
    }
}

int insert_chained(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node = (hash_node_t*)malloc(sizeof(hash_node_t));
        node->key = key;
        node->value = value;
        (ht->head)[hash] = insert_head((ht->head)[hash], node);
        return 1;
    }
    else
        return 0;
}

int insert_linear(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node = (hash_node_t*)malloc(sizeof(hash_node_t));
        node->key = key;
        node->value = value;
        unsigned int i;
        for (i = hash; i < ht->size; i++, *opcount += 1)
        {
            if ((ht->head)[i] == NULL)
            {
                (ht->head)[i] = node;
                return 1;
            }
        }
        for (i = 0; i != hash; i++, *opcount += 1)
        {
            if ((ht->head)[i] == NULL)
            {
                (ht->head)[i] = node;
                return 1;
            }
        }
        return 0;        
    }
    else
        return 0;
}

int insert_quadratic(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node = (hash_node_t*)malloc(sizeof(hash_node_t));
        node->key = key;
        node->value = value;
        if (((ht->head)[hash]) == NULL)
        {
            ((ht->head)[hash]) = node;
            return 1;
        }
        unsigned int i, j;
        for (i = ((hash+1) % ht->size), j = 1; (j < ht->size); 
            j++, i = ((hash+j*j) % ht->size))
        {
            *opcount += 1;
            if ((ht->head)[i] == NULL)
            {
                (ht->head)[i] = node;
                return 1;
            }
        }
        return 0;        
    }
    else
        return 0;
}

hash_node_t* search_chained(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node = (ht->head)[hash];
        if (node == NULL)
            return NULL;
        else
        {
            int res;
            for (; node != NULL; node = node->next, *opcount += 1)
            {             
                res = (ht->compare)(value, node->value); 
                if (res == 0)
                    return node;
            }
            return NULL;
        }
    }
    else
        return NULL;
}


hash_node_t* search_linear(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node;
        int res, i;
        for (i = hash; i < ht->size; i++, *opcount += 1)
        {
            node = (ht->head)[i];
            if (node == NULL)
                return NULL;
            res = (ht->compare)(node->value, value);
            if (res == 0)
                return node;
        }
        for (i = 0; i != hash; i++, *opcount += 1)
        {
            node = (ht->head)[i];
            if (node == NULL)
                return NULL;
            res = (ht->compare)(node->value, value);
            if (res == 0)
                return node;
        }
        return NULL;
    }
    else
        return NULL;
}




hash_node_t* search_quadratic(hash_table_t *ht, void *value, int *opcount)
{
    if (ht != NULL)
    {
        unsigned long int key = ((ht->getkey)(value));
        unsigned int hash = generate_hash(ht, key);
        hash_node_t *node;
        int res, i, j;
        for (i = hash, j = 0; (j < ht->size); 
            j++, i = ((hash+j*j) % ht->size), *opcount += 1)
        {
            node = (ht->head)[i];
            if (node == NULL)
                return NULL;
            res = (ht->compare)(node->value, value);
            if (res == 0)
                return node;
        }
        return NULL;
    }
    else
        return NULL;
}
