#ifndef LLIST_H
#define LLIST_H

typedef struct _llist_node llist_node;

struct _llist_node {
	void *item;
	llist_node *next;
};

typedef struct _llist {	
	llist_node *head;
	llist_node *tail;
} llist;

/* create_list
 * purpose: create a linked list structure and initialize to empty list
 * inputs: none
 * outputs: pointer to newly created and initialized linked list
 */
llist *create_llist();

/* insert_tail
 * purpose: insert an item to become the last item in a linked list.
 * inputs: 
 *   list - pointer to llist struct in which to insert item
 *   item - a pointer to the item to be inserted into the linked list
 * return: nothing
 */
void insert_tail(llist *list, void *item);

/* remove_head
 * purpose: remove the item that is at the beginning of a linked list
 * inputs: 
 *   list - pointer to llist struct in which to insert item
 * return:
 *   return the item held by the head pointer (before being removed)
 */

void *remove_head(llist *list);


/* list_is_empty
 * purpose: return a pseudo-boolean indicating whether or not the 
 *          list is empty
 * input: list
 * output: 0 if not empty, nonzero if empty
 */
int list_is_empty(llist *list);

/* iterator
 * purpose: over multiple function calls, return the different items
 * of the linked list.
 * input: NULL to continue in the same list, llist* to start a new list
 * output: NULL if run out, void* if there is an item
 */
void *iterate(llist *list);

#endif
