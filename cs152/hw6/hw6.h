#ifndef HW6_H
#define HW6_H
#include "bst.h"
#include "memory.h"

/* Takes in a filename, reads in the file
*  and splits the file into memory blocks.
*  Returns a pointer to the created bst.
*/
bst* read_memory_blocks(char *filename, 
  int (*cmp)(const void* x, const void* y));

#endif