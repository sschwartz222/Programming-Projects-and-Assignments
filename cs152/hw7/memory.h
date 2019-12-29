#ifndef MEMORY_H
#define MEMORY_H

/* This file contains the structs and function signatures for 
 * memory. A memory structure stores the memory address as 
 * well as the size of a memory slot. It has a constructor 
 * (memory_new), and two comparison functions, so they can be 
 * scored in a sorted data structure either by the memory 
 * address or by memory size. 
 */

typedef struct {
  void *addr;
  unsigned int size;
} memory;

/* memory_new
 * create a new memory struct, initialze its address and size
 */
memory* memory_new(void *addr, unsigned int size);

/* free the dynamically allocated memory struct
*/
void memory_free(void* p);

/* compare two memory variables x and y by address 
 * if x is less than y, return -1
 * if x is greater than y, return 1
 * if they are equal, return 0
 */
int memory_addr_cmp(const void* x, const void* y);

/* compare two memory variables x and y by size 
 * if x is less than y, return -1
 * if x is greater than y, return 1
 * if they are equal, return 0
 */
int memory_size_cmp(const void* x, const void* y);

/* print the memory address and size
*/
void memory_print(void* data);

/*****************************************************/
/****** Homework 7 Functions *************************/
/*****************************************************/

/* allocate_memory_page
 *
 * Call malloc to request a page of data - 4096 bytes. Create
 * a memory struct and initialize it to store the resulting
 * large chunk of data that was allocated. Return a pointer
 * to the memory struct.
 */
memory *allocate_memory_page();

/* split_memory
 *
 * Given a memory struct and a desired size of memory,
 * perform the operations necessary to remove the desired
 * size of memory from the end of the chunk and record
 * the new information for the smaller chunk. Return a 
 * pointer to the beginning of the chunk you are handing out.
 */
void *split_memory(memory* data, unsigned int size_desired);

/* merge_memory
 *
 * Given two memory structs, check to see if the two can be 
 * merged. They can be merged if the two are next to each other 
 * in memory with no break in between. If they can be merged,
 * return a memory struct pointer to a struct containing the information
 * for a single memory chunk containing the old two chunks.
 * If they cannot be merged (there is space between them), then
 * return NULL; 
 *
 * Make sure that you free any memory structs that you need to.
 */
memory *merge_memory(memory *first, memory *second);

#endif