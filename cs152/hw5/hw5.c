#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hw5.h"

char *category_strings[] = { "Grocery", "Office", "Pharmacy", "Hobby"};

void print_product(product_info *p, FILE *fp)
{
	fprintf(fp,"%s (%u) %s:",p->name, p->productID,
		category_strings[p->category]);
	fprintf(fp, "current: %u, min: %u, max: %u",
		p->current_stock, p->min_for_restock, p->max_after_restock);
}

void print_list(node *head, FILE *fp)
{
	node *tmp = head;
	printf("Product Status:\n");
	for(tmp = head; tmp != NULL; tmp = tmp->next)
	{
		print_product(tmp->product,fp);
		printf("\n");
	}
}

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
				uint current, uint mn, uint mx)
{
    int i;
	enum Category cat;
	product_info *newproduct = (product_info *) malloc(sizeof(product_info));
	for (i = 0; i < 4; i++)
	{
		if ((strcmp(category, category_strings[i])) == 0)
		{
			cat = i;
			break;
		}
	} 
	strcpy(newproduct->name, name);
	newproduct->category = cat;
	newproduct->productID = id;
	newproduct->current_stock = current; 
	newproduct->min_for_restock = mn;
	newproduct->max_after_restock = mx;
	return newproduct;  
}

/* insert_head
* inserts a node at the beginning of a list
* inputs:
*	*head - current head pointer
*	*pinfo - product pointer to be component of the new head
* output:
* 	returns a pointer to the new head of the list
*/
node* insert_head(node *head, product_info *pinfo)
{
	node *hd = (node *) malloc(sizeof(node));
	hd->next = head;
	hd->product = pinfo;
	return hd;
}

/* find
* finds an item with a certain pID given the head of a list
* inputs:
*	*head - pointer to the head of a list
*	pID - ID of product to be found
* output:
*	returns a pointer to the product found
*/
product_info *find(node *head, uint pID)
{
	while (head != NULL)
	{
		if (head->product->productID == pID)
			return head->product;
		head = head->next;
	}
	return NULL;
}

/* record_restocked_single
* restocks a single product with a certain product ID
* inputs:
*	*head - pointer to head of list to be searched
*	pID - id of product to be restocked
* output:
*	no return, but changes current stock to max
*/
void record_restocked_single(node *head, uint pID)
{
	product_info *pinfo = (find(head, pID));
	if (pinfo != NULL)
		pinfo->current_stock = pinfo->max_after_restock;
}

/* product_sold
* subtracts 1 from the current stock of an item
* inputs:
*	*head - pointer to head of list to be searched
*	pID - id of product to be acted on
* output:
*	no return, but subtracts 1 from the current stock
*/
void product_sold(node *head, uint pID)
{
	product_info *pinfo = (find(head, pID));
	if (pinfo != NULL)
		pinfo->current_stock -= 1;
}

/* add_sorted_productID
* adds an item to a list sorted by product ID
* inputs:
*	*pinfo - pointer to product to be added
*	*head - pointer to head of list to be added to
* output:
*	returns a pointer to the first node of the sorted list
*/
node *add_sorted_productID(product_info *pinfo, node *head)
{
	node *tmp = head;
	if (head == NULL) 
		return (insert_head(NULL, pinfo));
	else if (head->product->productID <= pinfo->productID)
		return (insert_head(head, pinfo));
	else
	{
		while (head != NULL)
		{
			if (head->next == NULL)
			{
				head->next = insert_head(NULL, pinfo);
				return tmp;
			}
			else if (head->next->product->productID <= pinfo->productID)
			{
				head->next = insert_head(head->next, pinfo);
				return tmp;
			}
			head = head->next;
		}
	}
}

/* add_sorted_category_ID
* adds an item to a list sorted by product ID and category
* inputs:
*	*pinfo - pointer to product to be added
*	*head - pointer to head of list to be added to
* output:
*	returns a pointer to the first node of the sorted list
*/
node *add_sorted_category_ID(product_info *pinfo, node *head)
{
	node *tmp = head;
	if (head == NULL)
		return (insert_head(NULL, pinfo));
	while ((head != NULL) && (head->next != NULL)
			&& (head->next->product != NULL)
			&& (head->next->product->category > pinfo->category))
		head = head->next;
	if (head->next == NULL)
	{
		head->next = insert_head(NULL, pinfo);
		return tmp;
	}
	else if (head->product->category == pinfo->category)
	{
		if (head->product->productID <= pinfo ->productID)
		{
			head = insert_head(head, pinfo);
			return head;
		}
		while (head != NULL)
		{
			if (head->next == NULL)
			{
				head->next = insert_head(NULL, pinfo);
				return tmp;
			}
			else if ((head->next->product->productID <= pinfo->productID)
					|| (head->next->product->category != pinfo->category))
			{
				head->next = insert_head(head->next, pinfo);
				return tmp;
			}
			head = head->next;
		}
	}
	else
	{
		if (head->next->product->productID <= pinfo->productID)
		{
			head->next = insert_head(head->next, pinfo);
			return tmp;
		}
		else
		{
			while (head != NULL)
			{
				if (head->next == NULL)
				{
					head->next = insert_head(NULL, pinfo);
					return tmp;
				}
				else if ((head->next->product->productID <= pinfo->productID)
						|| (head->next->product->category != pinfo->category))
				{
					head->next = insert_head(head->next, pinfo);
					return tmp;
				}
				head = head->next;
			}
		}
	}
}

/* make_restock_list
* makes a new list of items that need to be restocked
* inputs:
*	*head - pointer to head of list to be searched
* output:
*	returns pointer to newly created list with items that
* 	need to be restocked
*/
node *make_restock_list(node *head)
{
	node *restocklist = (node *) malloc(sizeof(node));
	restocklist = NULL;
	while (head != NULL)
	{
		if (head->product->current_stock < head->product->min_for_restock)
			restocklist = add_sorted_category_ID(head->product, restocklist);
		head = head->next;
	}
	return restocklist;
}

/* record_restocked_list
* restocks every element of a list
* inputs:
*	*restocked_list - pointer to first element of list of elements
*						to be restocked
*	*head - useless
* output:
*	no return but changes all current stocks to max
*/
void record_restocked_list(node *restocked_list, node *head)
{
	node *tmp = restocked_list;
	while (tmp != NULL)
	{
		tmp->product->current_stock = tmp->product->max_after_restock;
		tmp = tmp->next;
	}
}

