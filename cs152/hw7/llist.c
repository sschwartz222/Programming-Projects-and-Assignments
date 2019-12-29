#include <stdlib.h>
#include <stdio.h>
#include "llist.h"


/* create_list
 * purpose: create a linked list structure and initialize to empty list
 * inputs: none
 * outputs: pointer to newly created and initialized linked list
 */
llist *create_llist()
{
	llist *list = (llist*)malloc(sizeof(llist));
	list->head = NULL;
	list->tail = NULL;
	return list;
}

/* insert_tail
 * purpose: insert an item to become the last item in a linked list.
 * inputs: 
 *   list - pointer to llist struct in which to insert item
 *   item - a pointer to the item to be inserted into the linked list
 * return: nothing
 */
void insert_tail(llist *list, void *item)
{
	// if list is NULL, do nothing
	if (!list)
		return;

	llist_node *node = (llist_node*)malloc(sizeof(llist_node));
	node->item = item;
	node->next = NULL;

	// if head is NULL, this is only item
	if (!(list->head)) 
	{
		list->head = node;
		list->tail = node;
	}
	// if not, put at end
	else
	{
		list->tail->next = node;
		list->tail = node;
	}
}

/* remove_head
 * purpose: remove the item that is at the beginning of a linked list
 * inputs: 
 *   list - pointer to llist struct in which to insert item
 * return:
 *   return the item held by the head pointer (before being removed)
 */
void *remove_head(llist *list)
{
	if (!list || !(list->head))
		return NULL;
	llist_node *node = list->head;
	void *item = node->item;
	if (node == list->tail)
	{
		list->head = NULL;
		list->tail = NULL;
	}
	else
		list->head = list->head->next;
	free(node);
	return item;
}

/* list_is_empty
 * purpose: return a pseudo-boolean indicating whether or not the 
 *          list is empty
 * input: list
 * output: 0 if not empty, nonzero if empty
 */
int list_is_empty(llist *list)
{
	return (!list || !(list->head));
}

/* iterator
 * purpose: over multiple function calls, return the different items
 * of the linked list.
 * input: NULL to continue in the same list, llist* to start a new list
 * output: NULL if run out, void* if there is an item
 */
void *iterate(llist *list)
{
	// static variables persist across function calls
	// initialization occurs prior to program run - never during call
	static llist_node *node = NULL;
	// reinitialize
	if (list)
	{
		node = list->head;
	}
	if (!node)
		return NULL;
	// get out the item for the current node
	void *item = node->item;
	// advance for the next call
	node = node->next;
	return item;
}
