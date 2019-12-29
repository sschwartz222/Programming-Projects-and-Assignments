#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hw5.h"

// currently as written, these tests work with lists that are
// sorted by productID
// to make it work with those sorted by category and id, comment
// out the lines that use add_sorted_productID and uncomment
// the code that uses add_sorted_category_ID

int main(int argc, char *argv[])
{
	// make sure there are two arguments - hw5 and filename
	if (argc < 2)
	{
		printf("Usage: ./hw5 filename. Missing filename\n");
		exit(1);
	}
	char *filename = argv[1];
	// open file for reading
	FILE *fp = fopen(filename, "r");
	if (fp == NULL)
	{
		printf("Could not open file %s for reading\n",filename);
		exit(2);
	}

	// read in each record from the file
	char buffer[BUFSIZ];
	node *list = (node *) malloc(sizeof(node));
	list = NULL;
	product_info *testproduct = create_product("testproduct", 
								"Hobby", 400000, 2, 3, 7);
	product_info *testproduct2 = create_product("testproduct2", 
								"Pharmacy", 22000, 2, 3, 7);
	product_info *testproduct3 = create_product("testproduct3", 
								"Grocery", 1, 2, 3, 7);	
	while (!feof(fp) && (fgets(buffer,500,fp) != NULL))
	{
		// parse the line to split up the fields
		char *category;
		char *name;
		uint pID;
		uint current_stock;
		uint min_stock;
		uint max_stock;
		char *tmp_s;

		// first field is category
		category = strtok(buffer," ,\n\r");
		// second field is name
		name = strtok(NULL," ,\n\r");
		// third is pID;
		tmp_s = strtok(NULL," ,\n\r");
		pID = atoi(tmp_s);
		// fourth is current
		tmp_s = strtok(NULL," ,\n\r");
		current_stock = atoi(tmp_s);
		// fifth is min
		tmp_s = strtok(NULL," ,\n\r");
		min_stock = atoi(tmp_s);
		// sixth is max
		tmp_s = strtok(NULL," ,\n\r");
		max_stock = atoi(tmp_s);

		printf("Read in record: %s, %s, %u, %u, %u, %u\n",
			category, name, pID, current_stock, min_stock,
			max_stock);

		// creates a pointer to an item of type product_info as read
		product_info *record = create_product(name, category, pID,
									current_stock, min_stock, max_stock);
		
		// builds a linked list that is the reverse of what is read
		list = insert_head(list, record);
	}
	printf("\n");
	printf("This is the base list:\n");
	print_list(list, stdout);
	printf("\n");
	printf("Finds the item of id 23765 (printer)"
			", restocks it, and sells one stock\n");
	product_info *foundprod = find(list, 23765);
	print_product(foundprod, stdout);
	printf("\n");
	record_restocked_single(list, 23765);
	foundprod = find(list, 23765);
	print_product(foundprod, stdout);
	printf("\n");
	product_sold(list, 23765);
	foundprod = find(list, 23765);
	print_product(foundprod, stdout);
	printf("\n");
	//list = add_sorted_category_ID(testproduct, list);
	//list = add_sorted_category_ID(testproduct2, list);
	//list = add_sorted_category_ID(testproduct3, list);
	list = add_sorted_productID(testproduct, list);
	list = add_sorted_productID(testproduct2, list);
	list = add_sorted_productID(testproduct3, list);
	printf("\n");
	printf("Testing adding 3 different testproducts:\n");
	print_list(list, stdout);
	printf("\n");
	node *restocklist = make_restock_list(list);
	printf("List of items that need restocking:\n");
	print_list(restocklist, stdout);
	printf("\n");
	record_restocked_list(restocklist, NULL);
	printf("Restocked list:\n");
	print_list(restocklist, stdout);
	free(list);
}
