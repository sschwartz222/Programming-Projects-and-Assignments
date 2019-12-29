#ifndef MY_ALLOC_H
#define MY_ALLOC_H
#include <stdio.h>
#include <stdlib.h>
#include "memory.h"
#include "bst.h"

/* init_alloc
 *
 * Initializes the data structures of the allocator.
 * This must be called prior to any my_malloc and my_free calls.
 */
void init_alloc();

/* my_malloc
 * 
 * function that finds a piece of available memory that is at least
 * num_bytes size. A pointer to the beginning of the usable piece of
 * that chunk is returned.
 */
void *my_malloc(int num_bytes);


/* my_free
 * 
 * Function that returns the memory chunk whose usable piece starts
 * at that address back to the set of available memory so that it can
 * be reused in a subsequent free call
 */
void my_free(void *address);

/* bst_new_addr
 * 
 * function that generates a new bst sorted by address
 * given another bst
 * helper for compact
 * returns the pointer to the new bst
 */
bst *bst_new_addr(bst *b);

/* compact_memory
 * 
 * function that compacts avail_mem by first
 * resorting by address with bst_new_addr
 * then iterating through the tree and 
 * checking if in-order items can be merged
 * (and does so if they can)
 */
void compact_memory();

#endif
