#ifndef HW5_H
#define HW5_H

#include <stdio.h>
#include <stdlib.h>

typedef unsigned int uint;

enum Category { GROCERY=0, OFFICE, PHARMACY, HOBBY};
#define NUM_CATEGORIES 4

typedef struct {
 enum Category category;
 char name[40];
 uint productID;
 uint current_stock;
 uint min_for_restock;
 uint max_after_restock;
} product_info;

// for the linked list, we will use the following struct
typedef struct _node node;

struct _node{
 product_info *product;
 node *next;
};

extern char *category_strings[];
void print_product(product_info *g, FILE *fp);
void print_list(node *head, FILE *fp);

/* product_info
* creates a product given the appropriate info
* inputs:
*	*name - string for name
*	*category - string for category to be converted
*	id - product id number
*	current - current stock
*	mn - minimum before restocking
*	mx - max before restocking
* output:
*	returns a pointer to the created product
*/
product_info *create_product(char *name, char *category, uint id,
				uint current, uint mn, uint mx);

/* insert_head
* inserts a node at the beginning of a list
* inputs:
*	*head - current head pointer
*	*pinfo - product pointer to be component of the new head
* output:
* 	returns a pointer to the new head of the list
*/
node* insert_head(node *head, product_info *pinfo);

/* find
* finds an item with a certain pID given the head of a list
* inputs:
*	*head - pointer to the head of a list
*	pID - ID of product to be found
* output:
*	returns a pointer to the product found
*/
product_info *find(node *head, uint pID);

/* record_restocked_single
* restocks a single product with a certain product ID
* inputs:
*	*head - pointer to head of list to be searched
*	pID - id of product to be restocked
* output:
*	no return, but changes current stock to max
*/
void record_restocked_single(node *head, uint pID);

/* product_sold
* subtracts 1 from the current stock of an item
* inputs:
*	*head - pointer to head of list to be searched
*	pID - id of product to be acted on
* output:
*	no return, but subtracts 1 from the current stock
*/
void product_sold(node *head, uint pID);

/* add_sorted_productID
* adds an item to a list sorted by product ID
* inputs:
*	*pinfo - pointer to product to be added
*	*head - pointer to head of list to be added to
* output:
*	returns a pointer to the first node of the sorted list
*/
node *add_sorted_productID(product_info *pinfo, node *head);

/* add_sorted_category_ID
* adds an item to a list sorted by product ID and category
* inputs:
*	*pinfo - pointer to product to be added
*	*head - pointer to head of list to be added to
* output:
*	returns a pointer to the first node of the sorted list
*/
node *add_sorted_category_ID(product_info *pinfo, node *head);

/* make_restock_list
* makes a new list of items that need to be restocked
* inputs:
*	*head - pointer to head of list to be searched
* output:
*	returns pointer to newly created list with items that
* 	need to be restocked
*/
node *make_restock_list(node *head);

/* record_restocked_list
* restocks every element of a list
* inputs:
*	*restocked_list - pointer to first element of list of elements
*						to be restocked
*	*head - useless
* output:
*	no return but changes all current stocks to max
*/
void record_restocked_list(node *restocked_list, node *head);

#endif