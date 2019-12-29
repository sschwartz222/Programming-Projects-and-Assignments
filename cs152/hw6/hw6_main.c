#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "hw6.h"
#include "bst.h"
#include "memory.h"

int main()
{
    // bst with memory_addr_cmp
    printf("creating a bst using memory_addr_cmp:\n");
    bst* testbst = read_memory_blocks("testbst", memory_addr_cmp);
    printf("\nprinting the list via an in-order traversal:\n");
    bst_inorder_traversal(testbst, memory_print);
    memory* testmem1 = memory_new(0, 195);
    memory* testmem2 = memory_new(3, 60);
    bst_insert(testbst, testmem1);
    bst_insert(testbst, testmem2);
    printf("\ninserting new memory blocks of addr 0, size 195"
            " and addr 3, size 60:\n");
    bst_inorder_traversal(testbst, memory_print);
    memory* testmem3 = memory_new(1, 200);
    bst_delete(testbst, testmem3);
    printf("\ndeleting node with memory block of addr 1, size 200:\n");
    bst_inorder_traversal(testbst, memory_print);
    printf("\ndeleting node with memory block of addr 1, size 200"
            " (expect no change):\n");
    bst_inorder_traversal(testbst, memory_print);
    printf("\ntesting bst_search, searching for memory block of addr"
            " 3, size 60:\n");
    memory_print(bst_search(testbst, testmem2));
    printf("\ntesting bst_search, searching for memory block of addr"
            " 1, size 195 (expect nothing):\n");
    memory_print(bst_search(testbst, testmem3));
    // bst with memory_size_cmp
    printf("\ncreating a bst using memory_size_cmp:\n");
    testbst = read_memory_blocks("testbst", memory_size_cmp);
    printf("\nprinting the list via an in-order traversal:\n");
    bst_inorder_traversal(testbst, memory_print);
    testmem1 = memory_new(0, 195);
    testmem2 = memory_new(3, 60);
    bst_insert(testbst, testmem1);
    bst_insert(testbst, testmem2);
    printf("\ninserting new memory blocks of addr 0, size 195"
            " and addr 3, size 60:\n");
    bst_inorder_traversal(testbst, memory_print);
    testmem3 = memory_new(1, 200);
    bst_delete(testbst, testmem3);
    printf("\ndeleting node with memory block of addr 1, size 200:\n");
    bst_inorder_traversal(testbst, memory_print);
    printf("\ndeleting node with memory block of addr 1, size 200"
            " (expect no change):\n");
    bst_inorder_traversal(testbst, memory_print);
    printf("\ntesting bst_search, searching for memory block of addr"
            " 3, size 60:\n");
    memory_print(bst_search(testbst, testmem2));
    printf("\ntesting bst_search, searching for memory block of addr"
            " 1, size 195 (expect nothing):\n");
    memory_print(bst_search(testbst, testmem3));
    free(testbst);
    free(testmem1);
    free(testmem2);
    free(testmem3);
}