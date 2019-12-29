#include<stdio.h>
#include<stdlib.h>
#include "bst.h"
#include "memory.h"
/* malloc a new node and assign the data
 * pointer to its data field
 */
node* node_new(void* data)
{
  node* nd = (node*)malloc(sizeof(node));
  nd->data = data; 
  nd->left = NULL;
  nd->right = NULL;
  return nd;
}

/* create a new bst, initialize its root to be NULL
 */
bst* bst_new(int (*cmp)(const void* x, const void* y)){
  bst* newbst = (bst *)malloc(sizeof(bst));
  newbst->root = NULL;
  newbst->cmp = cmp;
  return newbst;
}

/* Insert a node to to a subtree with a root node as parameter
 * Insertion is in sorted order. 
 * Return the new root of the modified subtree.  
 */
node* node_insert(node* root, void* data, 
    int (*cmp)(const void* x, const void* y))
{
  if (root == NULL)
    {
        root = node_new(data);
        return root;
    }
  int result = (*cmp)(root->data, data);
  if (result == -1)
        root->right = node_insert(root->right, data, cmp);
  else if ((result == 1) || (result == 0))
        root->left = node_insert(root->left, data, cmp);
  return root;
}

/* Insert a new node to the bst
 */
void bst_insert(bst* b, void* data)
{
  if (b != NULL)
    b->root = node_insert(b->root, data, b->cmp);
}

/* Helper for going to the min of a tree (most left)
*/
node* min_node(node* root)
{
    node* temp = root;
    while (temp->left != NULL)
        temp = temp->left;
    return temp;
}
/* delete a node from a subtree with a given root node
 * use the comparison function to search the node and delete 
 * it when a matching node is found. This function only
 * deletes the first occurrence of the node, i.e, if multiple 
 * nodes contain the data we are looking for, only the first node 
 * we found is deleted. 
 * Return the new root node after deletion.
 */
node* node_delete(node* root, void* data, 
    int (*cmp)(const void* x, const void* y)){
  node* nd;
  if (root == NULL)
    return NULL;
  int result = (*cmp)(root->data, data);
  if (result == -1)
  {
      root->right = node_delete(root->right, data, cmp);
  }
  else if (result == 1)
  {
      root->left = node_delete(root->left, data, cmp);
  }
  else
  {
      if (root->right == NULL)
      {
          nd = root->left;
          free(root);
          return nd;
      }
      else if (root->left == NULL)
      {
          nd = root->right;
          free(root);
          return nd;
      }
    node* temp = min_node(root->right);
    root->data = temp->data;
    root->right = node_delete(root->right, temp->data, cmp);
  }
  return root;  
}

/* delete a node containing data from the bst
 */
void bst_delete(bst* b, void* data){
  if (b != NULL)
  {
      b->root = node_delete(b->root, data, b->cmp);
  }
}

/* Search for a node containing data in a subtree with
 * a given root node. Use recursion to search that node. 
 * Return the first occurrence of node. 
 */
void* node_search(node* root, void* data, 
    int (*cmp)(const void* x, const void* y))
{
  void* nd;
  if (root == NULL)
    return NULL;
  int result = (*cmp)(root->data, data);
  if (result == -1)
  {
      nd = node_search(root->right, data, cmp);
      return nd;
  }
  else if (result == 0)
    return (root->data);
  else if (result == 1)
  {
      nd = node_search(root->left, data, cmp);
      return nd;
  }
}

/* Search a node with data in a bst. 
 */
void* bst_search(bst* b, void* data){
  if (b != NULL)
  {
      void* result = node_search(b->root, data, b->cmp);
      return result;
  }
  else
    return NULL;
}

/* traverse a subtree with root in ascending order. 
 * Apply func to the data of each node. 
 */
void inorder_traversal(node* root, void(*func)(void* data)){
  if (root != NULL)
  {
      inorder_traversal(root->left, func);
      (*func)(root->data);
      inorder_traversal(root->right, func);
  }
}

/* traverse a bst in ascending order. 
 * Apply func to the data of each node. 
 */
void bst_inorder_traversal(bst* b, void(*func)(void* data)){
  if (b != NULL)
    inorder_traversal(b->root, func);
}

/* frees each node of a tree via a postorder traversal
*/
void postorder_traversal_free(node* root){
  if (root == NULL)
    return;
  postorder_traversal_free(root->left);
  postorder_traversal_free(root->right);
  free(root);
}
/* free the bst with 
 */
void bst_free(bst* b){
  if (b != NULL)
    postorder_traversal_free(b->root);
  free(b);
}





