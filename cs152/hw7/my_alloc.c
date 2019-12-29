#include <stdio.h>
#include <stdlib.h>
#include "bst.h"
#include "memory.h"

/* Global variables
 * By declaring these outside of a function:
 *   Scope: Every function inside of this file may use them. 
 *   		No functions in other files may use them.
 *   Lifetime: They exist for the entire program - they are created
 *		when the program begins and exist until the program
 *		ends.
 */   		

/* This is the tree that holds the available memory. */
bst *avail_mem = NULL;

/* This includes all of the functions for the memory allocator.
 * The last two functions (my_malloc and my_free) are public 
 * functions with prototypes in the header function. The rest of the
 * functions are helper functions only called by my_malloc and 
 * my_free. You must implement these helper functions. If you wish,
 * you may add helper functions we did not define.
 */

/* init_alloc
 *
 * Initializes the data structures. This initializes avail_mem so 
 * that, instead of being a NULL pointer, it points to a valid bst
 * struct whose root pointer is NULL.
 */
void init_alloc()
{
	avail_mem = bst_new(memory_size_cmp);
}

/* bst_new_addr
 * 
 * function that generates a new bst sorted by address
 * given another bst
 * helper for compact
 * returns the pointer to the new bst
 */
bst *bst_new_addr(bst *b)
{
    if (b == NULL)
        return NULL;
    bst *newbst = bst_new(memory_addr_cmp);
    void* i;
    for(i = bst_iterate(b); i != NULL; (i = bst_iterate(NULL)))
        bst_insert(newbst, i);
    return newbst;
}

/* bst_new_size
 * 
 * function that generates a new bst sorted by address
 * given another bst
 * helper for compact
 * returns the pointer to the new bst
 */
bst *bst_new_size(bst *b)
{
    if (b == NULL)
        return NULL;
    bst *newbst = bst_new(memory_size_cmp);
    void* i;
    for(i = bst_iterate(b); i != NULL; (i = bst_iterate(NULL)))
        bst_insert(newbst, i);
    return newbst;
}

/* compact_memory
 * 
 * function that compacts avail_mem by first
 * resorting by address with bst_new_addr
 * then iterating through the tree and 
 * checking if in-order items can be merged
 * (and does so if they can)
 */
void compact_memory()
{
    bst *b = bst_new_addr(avail_mem);
    void *i, *j;
    memory* mem;
    for(i = bst_iterate(b), j = bst_iterate(NULL);
        ((i != NULL) && (j != NULL));
        (j = bst_iterate(NULL)))
    {
        mem = merge_memory(i, j);
        if (mem == NULL)
            i = j;
        else
        {
            ((memory*)i)->addr = mem->addr;
            ((memory*)i)->size = mem->size;
            bst_delete(b, j);
        }
    }
    avail_mem = bst_new_size(b);
}

/* my_malloc
 * 
 * function that finds a piece of available memory that is at least
 * num_bytes size. A pointer to the beginning of the usable piece of
 * that chunk is returned.
 */
void *my_malloc(unsigned int num_bytes)
{
	if (num_bytes % 8 != 0)
        num_bytes += (8 - (num_bytes % 8));
    memory* mem = memory_new(NULL, num_bytes);
    void *pointer = bst_item_or_successor(avail_mem, mem);
    printf("\nmy_malloc(%d) printing the result of bst_item_or_successor " 
            "for testing purposes:\n", num_bytes);
    memory_print(pointer);
    if (pointer == NULL)
    {
        compact_memory();
        printf("\ncompacted\n");
        pointer = bst_item_or_successor(avail_mem, mem);
        if (pointer == NULL)
        {
            printf("\ncompacted and found nothing\n");
            memory *page = allocate_memory_page();
            void *rt = split_memory(page, num_bytes);
            bst_insert(avail_mem, page);
            return rt;
        }
        else if ((((memory*)pointer)->size) >= 2*num_bytes)
        {
            void *rt = split_memory(pointer, num_bytes);
            return rt;
        }
        else
        {
            bst_delete(avail_mem, pointer);
            return (((memory*)pointer)->addr);
        }
    }
    if ((((memory*)pointer)->size) >= 2*num_bytes)
    {
        void *rt = split_memory(pointer, num_bytes);
        return rt;
    }
    else
    {
        bst_delete(avail_mem, pointer);
        return (((memory*)pointer)->addr);
    }
}
/* my_free
 * 
 * Function that returns the memory chunk whose usable piece starts
 * at that address back to the set of available memory so that it can
 * be reused in a subsequent free call
 */
void my_free(void *address)
{
    char* size = address;
    size -= 8;
    memory* mem = memory_new(address, *((long*)size));
	bst_insert(avail_mem, mem);
}

