#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "hw6.h"
#define BUFSIZ 120

/* Takes in a filename, reads in the file
*  and splits the file into memory blocks.
*  Returns a pointer to the created bst.
*/
bst* read_memory_blocks(char *filename, 
  int (*cmp)(const void* x, const void* y))
{
  FILE *fp;
  char buf[BUFSIZ] = "Garbage";
  bst* _bst = bst_new(cmp);

  // attempt to open the file, then check whether that worked.
  if ((fp = fopen(filename, "r")) == NULL)
  {
    fprintf(stderr,"Could not open file %s\n",filename);
    return (NULL);
  }

  // for each line of the file, read it in and then print it out
  while (!feof(fp))
  {
      if (fgets(buf, sizeof(buf), fp) != NULL)
      {
        char *tokenPtr;
        tokenPtr = strtok(buf, " ,\n\r");
        int temp = atoi(tokenPtr);
        tokenPtr = strtok(NULL, " ,\n\r");
        int temp2 = atoi(tokenPtr);
        memory* mem = memory_new(temp, temp2);
        bst_insert(_bst, mem);
        printf("read memory data:");
        memory_print(mem);   
      }
  }
  fclose(fp);
  return _bst;
}