#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "my_alloc.h"
#include "bst.h"
#include "memory.h"
#include "llist.h"
extern bst *avail_mem;

int main()
{
    memory* m = allocate_memory_page();
    printf("allocating one page of memory and printing:\n");
    memory_print(m);
    printf("\n\nsplitting this page into a 128 byte chunk:\n");
    void* testsplit = split_memory(m, 128);
    memory* n = memory_new(testsplit, 128);
    memory_print(m);
    memory_print(n);
    printf("\n\ncalling my_malloc on 1000, 500, and 3000, printed in order:\n");
    init_alloc();
    my_malloc(1000);
    my_malloc(500);
    void* a = my_malloc(3000);
    printf("\navail_mem:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    my_free(a);
    printf("\n\ncalling my_free on the my_malloc of 3000:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    init_alloc();
    printf("\n\nprinting new tree with my_malloc call of 128:\n");
    a = my_malloc(128);
    printf("\navail_mem:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    memory* mem = memory_new(a, 128);
    //memory* b = (memory*) avail_mem->root->data;
    //printf("%d\n", b->addr);
    //printf("%d\n", mem->addr);
    printf("\n\nmerging the my_malloc call of 128 with the tree memory:\n");
    mem = merge_memory(avail_mem->root->data, mem);
    memory_print(mem);
    init_alloc();
    printf("\n\nstarting new bst with my_malloc on 3000, 3008,"
            " 3016, 2992, 1084, 100:\n");
    my_malloc(3000);
    my_malloc(3008);
    my_malloc(3016);
    my_malloc(2992);
    my_malloc(1084);
    my_malloc(100);
    printf("\navail_mem:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    bst *c = bst_new_addr(avail_mem);
    printf("\n\nsorting that bst by address:\n");
    bst_inorder_traversal(c, memory_print);
    printf("\n\ntesting compact and bst_item_or_successor on this new tree,"
            "which calls my_malloc on 80, 72, and 88:\n");
    init_alloc();
    void *x = my_malloc(80);
    void *y = my_malloc(72);
    void *z = my_malloc(88);
    printf("\navail_mem:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    my_free(x);
    my_free(y);
    my_free(z);
    printf("\n\nafter free:\n");
    bst_inorder_traversal(avail_mem, memory_print);
    compact_memory();
    printf("\n\ncompact:\n");
    bst_inorder_traversal(avail_mem, memory_print);   
}