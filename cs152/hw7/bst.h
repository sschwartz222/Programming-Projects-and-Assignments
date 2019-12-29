#ifndef BST_H
#define BST_H
#include "llist.h"

typedef struct _node{
  void* data;
  struct _node* left;
  struct _node* right;
}node;

typedef struct{
  node* root;
  int (*cmp)(const void* x, const void* y);
}bst;
/* malloc a new node and assign the data
 * pointer to its data field
 */
node* node_new(void* data);

/* create a new bst, initialize its root to be NULL
*/
bst* bst_new(int (*cmp)(const void* x, const void* y));

/* Insert a node to to a subtree with a root node as parameter
 * Insertion is in sorted order. 
 * Return the new root of the modified subtree.  
 */
node* node_insert(node* root, void* data, 
    int (*cmp)(const void* x, const void* y));

/* Insert a new node to the bst
*/
void bst_insert(bst* b, void* data);

/* delete a node from a subtree with a given root node
 * use the comparison function to search the node and delete 
 * it when a matching node is found. This function only
 * deletes the first occurrence of the node, i.e, if multiple 
 * nodes contain the data we are looking for, only the first node 
 * we found is deleted. 
 * Return the new root node after deletion.
 */
node* node_delete(node* root, void* data, 
    int (*cmp)(const void* x, const void* y));

/* delete a node containing data from the bst
*/
void bst_delete(bst* b, void* data);

/* Search for a node containing data in a subtree with
 * a given root node. Use recursion to search that node. 
 * Return the first occurrence of node. 
 */
void* node_search(node* root, void* data, 
    int (*cmp)(const void* x, const void* y));

/* Search a node with data in a bst. 
*/
void* bst_search(bst* b, void* data);

/* traverse a subtree with root in ascending order. 
 * Apply func to the data of each node. 
 */
void inorder_traversal(node* root, void(*func)(void* data));

/* traverse a bst in ascending order. 
 * Apply func to the data of each node. 
 */
void bst_inorder_traversal(bst* b, void(*func)(void* data));

// a helper function to create linked list from bst by in order traversal
void inorder_traversal_insert_llist(node* root, llist* l);

/* an iterator to iterate through the bst in ascending order
*/
void* bst_iterate(bst* b);

/* free the bst with 
*/
void bst_free(bst* b);

/*****************************
 *    HOMEWORK 7
 *****************************/
/* 
 * item_or_successor
 * 
 * find an item that is equal or, if there isn't one that is 
 * equal, find the one that is next larger to the requested
 * item.
 *
 * The purpose of this function is that, given a size of a 
 * chunk of memory desired, it attempts to find an available
 * chunk of memory the same size. If there is no chunk of 
 * memory the same size, it finds the chunk of memory that is 
 * closest to that size but larger.
 *
 * It returns a pointer to the memory struct. The compare function
 * in the bst is the one that performs the comparisons.
 */
void* node_item_or_successor(node *n, void *item, 
    	int (*cmp)(const void* x, const void* y));
void* bst_item_or_successor(bst *b, void *item);
#endif