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
  unsigned int addr;
  unsigned int size;
}memory;

/* memory_new
 * create a new memory struct, initialze its address and size
 */
memory* memory_new(unsigned int addr, unsigned int size);

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
#endif