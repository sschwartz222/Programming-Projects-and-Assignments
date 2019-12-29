#include<stdio.h>
#include<stdlib.h>
#include "memory.h"

/* memory_new
 * create a new memory struct, initialze its address and size
 */
memory* memory_new(void* addr, unsigned int size){
  memory* m = (memory*)malloc(sizeof(memory));
  m->addr = addr;
  m->size = size;
  return m;
}

/* free the dynamically allocated memory struct
 */
void memory_free(void* p){
  memory* m = (memory*)p;
  free(m);
}

/* compare two memory variables x and y by address 
 * if x is less than y, return -1
 * if x is greater than y, return 1
 * if they are equal, return 0
 */
int memory_addr_cmp(const void* x, const void* y){
  if ((x == NULL) || (y == NULL))
    return 2;
  memory* xmem = (memory *) x;
  memory* ymem = (memory *) y;
  if ((xmem->addr) < (ymem->addr))
    return -1;
  else if ((xmem->addr) == (ymem->addr))
    return 0;
  else  
    return 1;
}

/* compare two memory variables x and y by size 
 * if x is less than y, return -1
 * if x is greater than y, return 1
 * if they are equal, return 0
 */
int memory_size_cmp(const void* x, const void* y){
  if ((x == NULL) || (y == NULL))
    return 2;  
  memory* xmem = (memory *) x;
  memory* ymem = (memory *) y;
  if (xmem->size < ymem->size)
    return -1;
  else if (xmem->size == ymem->size)
    return 0;
  else  
    return 1;
}

/* print the memory address and size
 */
void memory_print(void* data){
  if (data == NULL) return;
  memory* m = (memory*)data;
  printf("address: %p, size: %u\n", m->addr, m->size);
}

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
memory *merge_memory(memory *first, memory *second)
{
    if ((first == NULL) || (second == NULL))
        return NULL;
    if (((char*)(first->addr) + (first->size) + 16) == (second->addr))
    {
        memory* mem = memory_new(first->addr, 
                                ((second->size)+(first->size)+8));
        return mem;
    }
    else   
        return NULL;
}

/* allocate_memory_page
 *
 * allocate one page (4096 bytes) of memory 
 */
memory* allocate_memory_page(){
	memory* ret_val = (memory*)malloc(sizeof(memory));
    ret_val->addr = malloc(4096);
    ret_val->size = 4088;
    *((long*)ret_val->addr) = 4088;
	return ret_val;
}

/* split_memory
 *
 * split memory into two parts
 * inputs
 *   memory* data - the memory to be split
 *   size_desired - the size of memory to return
 */
void* split_memory(memory* data, unsigned int size_desired){
    char *pointer = (char*)(data->addr);
    pointer += ((data->size) - size_desired + 8);
    void *ret_val = pointer;
    pointer -= 8;
    *((long*)pointer) = (long) size_desired;
    data->size -= (size_desired + 8);
    return ret_val;
}