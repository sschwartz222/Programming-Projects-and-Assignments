/*
 * mm.c
 *
 * This is the only file you should modify.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "mm.h"
#include "memlib.h"

/* If you want debugging output, use the following macro.  When you hand
 * in, remove the #define DEBUG line. */
//#define DEBUG
//#ifdef DEBUG
//# define dbg_printf(...) printf(__VA_ARGS__)
//#else
//# define dbg_printf(...)
//#endif


/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(p) (((size_t)(p) + (ALIGNMENT-1)) & ~0x7)

#define WSIZE       4       /* word size (bytes) */  
#define DSIZE       8       /* doubleword size (bytes) */
#define CHUNKSIZE  (1<<12)  /* initial heap size (bytes) */
#define OVERHEAD    24       /* overhead of header and footer (bytes) */

#define MAX(x, y) ((x) > (y)? (x) : (y))  

/* Pack a size and allocated bit into a word */
#define PACK(size, alloc)  ((size) | (alloc))

/* Read and write a word at address p */
/* NB: this code calls a 32-bit quantity a word */
#define GET(p)       (*(unsigned int *)(p))
#define PUT(p, val)  (*(unsigned int *)(p) = (val))  

/* Read the size and allocated fields from address p */
#define GET_SIZE(p)  (GET(p) & ~0x7)
#define GET_ALLOC(p) (GET(p) & 0x1)

/* Given block ptr bp, compute address of its header and footer */
#define HDRP(bp)       ((char *)(bp) - WSIZE)  
#define FTRP(bp)       ((char *)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

/* Given block ptr bp, compute address of next and previous blocks */
#define NEXT_BLKP(bp)  ((char *)(bp) + GET_SIZE(((char *)(bp) - WSIZE)))
#define PREV_BLKP(bp)  ((char *)(bp) - GET_SIZE(((char *)(bp) - DSIZE)))

//for explicit list: given pointer in the free list, get the last and next pointers
#define NEXT_FREE(bp)  (*(char **)(bp + DSIZE))
#define PREV_FREE(bp)  (*(char **)(bp))
#define SET_NEXT(bp, np)  (NEXT_FREE(bp) = np)
#define SET_PREV(bp, pp)  (PREV_FREE(bp) = pp)

/* $end mallocmacros */

/* Global variables */
static char *heap_listp = 0;  /* pointer to first block */  
static char *free_listp = 0;
#ifdef NEXT_FIT
static char *rover;       /* next fit rover */
#endif

/* function prototypes for internal helper routines */
static void *extend_heap(size_t words);
static void place(void *bp, size_t asize);
static void *find_fit(size_t asize);
static void *coalesce(void *bp);
static void printblock(void *bp); 
static void checkblock(void *bp);
static void freelist_insert(void *bp);
static void freelist_remove(void *bp);

/* 
 * mm_init - Initialize the memory manager 
 */
/* $begin mminit */
int mm_init(void) 
{
  /* create the initial empty heap */
  if ((heap_listp = mem_sbrk(48)) == NULL)
    return -1;
  PUT(heap_listp, 0);                        /* alignment padding */
  PUT(heap_listp+WSIZE, PACK(OVERHEAD, 1));  /* prologue header */ 
  PUT(heap_listp+DSIZE, 0);  /* prologue footer */ 
  PUT(heap_listp+WSIZE+DSIZE, 0); 
  PUT(heap_listp+OVERHEAD, PACK(OVERHEAD, 1));
  PUT(heap_listp+WSIZE+OVERHEAD, PACK(0,1));  /* epilogue header */
  free_listp = heap_listp + DSIZE;
  //heap_listp += DSIZE;

#ifdef NEXT_FIT
  rover = heap_listp;
#endif
    //maybe have choice for initial size?
  /* Extend the empty heap with a free block of CHUNKSIZE bytes */
  if (extend_heap(4) == NULL)
    return -1;
  return 0;
}
/* $end mminit */

/*
 * malloc - Allocate a block with at least size bytes of payload 
 */
/* $begin mmmalloc */
void *mm_malloc(size_t size)
{
  size_t asize;      /* adjusted block size */
  size_t extendsize; /* amount to extend heap if no fit */
  char *bp;      
  //if (heap_listp == 0){
  //  mm_init();
  //}

  /* Ignore spurious requests */
  if (size <= 0)
    return NULL;

  /* Adjust block size to include overhead and alignment reqs. */
  if (size <= DSIZE)
    asize = DSIZE + OVERHEAD;
  else
    asize = DSIZE * ((size + (OVERHEAD) + (DSIZE-1)) / DSIZE);

  /* Search the free list for a fit */
  if ((bp = find_fit(asize)) != NULL) {
    place(bp, asize);
    return bp;
  }

  /* No fit found. Get more memory and place the block */
  extendsize = MAX(asize,CHUNKSIZE);
  if ((bp = extend_heap(extendsize/WSIZE)) == NULL)
    return NULL;
  place(bp, asize);
  return bp;
} 
/* $end mmmalloc */

/* 
 * free - Free a block 
 */
/* $begin mmfree */
void mm_free(void *bp)
{
  if(bp == NULL) return;

  size_t size = GET_SIZE(HDRP(bp));
  //if (heap_listp == 0){
  //  mm_init();
  //}



  PUT(HDRP(bp), PACK(size, 0));
  PUT(FTRP(bp), PACK(size, 0));
  coalesce(bp);
  mm_checkheap(0);
}

/* $end mmfree */

/*
 * realloc - naive implementation of realloc
 */
void *mm_realloc(void *ptr, size_t size)
{
  size_t oldsize;
  size_t newsize;
  //size_t nextblock;
  //size_t totalsize;
  void *newptr;

  /* If size == 0 then this is just free, and we return NULL. */
  if(size == 0) {
    mm_free(ptr);
    return NULL;
  }

  /* If oldptr is NULL, then this is just malloc. */
  if(ptr == NULL) {
    return mm_malloc(size);
  }

  if(size > 0){
      oldsize = GET_SIZE(HDRP(ptr));
      newsize = MAX(ALIGN(size) + DSIZE, OVERHEAD);
      if(oldsize == newsize)
        return ptr;
      if(newsize <= oldsize){
        if(oldsize-size <= OVERHEAD)
          return ptr;
        //nextblock = GET_ALLOC(HDRP(NEXT_BLKP(ptr)));
        //totalsize = oldsize + GET_SIZE(HDRP(NEXT_BLKP(ptr)));
        //if((nextblock == 0) && (totalsize >= newsize)){
            //freelist_remove(NEXT_BLKP(ptr));
            PUT(HDRP(ptr), PACK(newsize, 1));
            PUT(FTRP(ptr), PACK(newsize, 1));
            PUT(HDRP(NEXT_BLKP(ptr)), PACK(oldsize-size, 1));
            mm_free(NEXT_BLKP(ptr));
            return ptr;
      }
      else{
        newptr = mm_malloc(newsize);
        if(!newptr)
          return 0;
        if(size<oldsize)
          oldsize = size;
        memcpy(newptr, ptr, oldsize);
        mm_free(ptr);
        return newptr;               
      }
  }
  else{
    return NULL;
  }
}

/* 
 * checkheap - Minimal check of the heap for consistency 
 */
void mm_checkheap(int verbose)
{
  char *bp = heap_listp;

  if (verbose)
    printf("Heap (%p):\n", heap_listp);

  if ((GET_SIZE(HDRP(heap_listp)) != DSIZE) || !GET_ALLOC(HDRP(heap_listp)))
    printf("Bad prologue header\n");
  checkblock(heap_listp);

  for (bp = heap_listp; GET_SIZE(HDRP(bp)) > 0; bp = NEXT_BLKP(bp)) {
    if (verbose) 
      printblock(bp);
    checkblock(bp);
  }

  if (verbose)
    printblock(bp);
  if ((GET_SIZE(HDRP(bp)) != 0) || !(GET_ALLOC(HDRP(bp))))
    printf("Bad epilogue header\n");
}

/* The remaining routines are internal helper routines */

/* 
 * extend_heap - Extend heap with free block and return its block pointer
 */
/* $begin mmextendheap */
static void *extend_heap(size_t words) 
{
  char *bp;
  size_t size;
  void *return_ptr;

  /* Allocate an even number of words to maintain alignment */
  size = (words % 2) ? (words+1) * WSIZE : words * WSIZE;
  if ((long)(bp = mem_sbrk(size)) < 0) 
    return NULL;

  /* Initialize free block header/footer and the epilogue header */
  PUT(HDRP(bp), PACK(size, 0));         /* free block header */
  PUT(FTRP(bp), PACK(size, 0));         /* free block footer */
  PUT(HDRP(NEXT_BLKP(bp)), PACK(0, 1)); /* new epilogue header */

  /* Coalesce if the previous block was free */
  return_ptr = coalesce(bp);
  mm_checkheap(0);
  return return_ptr;
}
/* $end mmextendheap */

/* 
 * place - Place block of asize bytes at start of free block bp 
 *         and split if remainder would be at least minimum block size
 */
/* $begin mmplace */
/* $begin mmplace-proto */
static void place(void *bp, size_t asize)
  /* $end mmplace-proto */
{
  size_t csize = GET_SIZE(HDRP(bp));   

  if ((csize - asize) >= (OVERHEAD)) { 
    PUT(HDRP(bp), PACK(asize, 1));
    PUT(FTRP(bp), PACK(asize, 1));
    freelist_remove(bp);
    bp = NEXT_BLKP(bp);
    PUT(HDRP(bp), PACK(csize-asize, 0));
    PUT(FTRP(bp), PACK(csize-asize, 0));
    coalesce(bp);
  }
  else { 
    PUT(HDRP(bp), PACK(csize, 1));
    PUT(FTRP(bp), PACK(csize, 1));
    freelist_remove(bp);
  }
}
/* $end mmplace */

/* 
 * find_fit - Find a fit for a block with asize bytes 
 */
static void *find_fit(size_t asize)
{
#ifdef NEXT_FIT 
  /* next fit search */
  char *oldrover = rover;

  /* search from the rover to the end of list */
  for ( ; GET_SIZE(HDRP(rover)) > 0; rover = NEXT_BLKP(rover))
    if (!GET_ALLOC(HDRP(rover)) && (asize <= GET_SIZE(HDRP(rover))))
      return rover;

  /* search from start of list to old rover */
  for (rover = heap_listp; rover < oldrover; rover = NEXT_BLKP(rover))
    if (!GET_ALLOC(HDRP(rover)) && (asize <= GET_SIZE(HDRP(rover))))
      return rover;

  return NULL;  /* no fit found */
#else 
  /* first fit search */
  void *bp;
  //static int last_size = 0;
  //static int i = 0;
  /*if(last_size == (int)asize){
      if(i > 30){
          bp = extend_heap(MAX(asize/4, 4));
          return bp;
      }
      else
        i++;
  }
  else
    i = 0;*/
  for (bp = free_listp; GET_ALLOC(HDRP(bp)) == 0; bp = NEXT_FREE(bp)) {
    if (asize <= (GET_SIZE(HDRP(bp)))){
        //last_size = asize;
        return bp;
    }
  }  
  return NULL; /* no fit */
#endif
}

/*
 * coalesce - boundary tag coalescing. Return ptr to coalesced block
 */
static void *coalesce(void *bp) 
{
  size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp))) || PREV_BLKP(bp) == bp;
  size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
  size_t size = GET_SIZE(HDRP(bp));

  if (prev_alloc && next_alloc) {            /* Case 1 */
    return bp;
  }

  else if (prev_alloc && !next_alloc) {      /* Case 2 */
    size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
    freelist_remove(NEXT_BLKP(bp));
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size,0));
  }

  else if (!prev_alloc && next_alloc) {      /* Case 3 */
    size += GET_SIZE(HDRP(PREV_BLKP(bp)));
    bp = PREV_BLKP(bp);
    freelist_remove(bp);
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
  }

  else {                                     /* Case 4 */
    size += GET_SIZE(HDRP(PREV_BLKP(bp))) + 
      GET_SIZE(HDRP(NEXT_BLKP(bp)));
    freelist_remove(PREV_BLKP(bp));
    freelist_remove(NEXT_BLKP(bp));
    PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
    PUT(FTRP(NEXT_BLKP(bp)), PACK(size, 0));
    bp = PREV_BLKP(bp);
  }

#ifdef NEXT_FIT
  /* Make sure the rover isn't pointing into the free block */
  /* that we just coalesced */
  if ((rover > (char *)bp) && (rover < NEXT_BLKP(bp))) 
    rover = bp;
#endif
  freelist_insert(bp);
  return bp;
}


static void printblock(void *bp) 
{
  size_t hsize;//, halloc, fsize, falloc;

  hsize = GET_SIZE(HDRP(bp));
  //halloc = GET_ALLOC(HDRP(bp));  
  //fsize = GET_SIZE(FTRP(bp));
  //falloc = GET_ALLOC(FTRP(bp));  

  if (hsize == 0) {
    printf("%p: EOL\n", bp);
    return;
  }

  /*  printf("%p: header: [%p:%c] footer: [%p:%c]\n", bp, 
      hsize, (halloc ? 'a' : 'f'), 
      fsize, (falloc ? 'a' : 'f')); */
}

static void checkblock(void *bp) 
{
  if ((size_t)bp % 8)
    printf("Error: %p is not doubleword aligned\n", bp);
  if (GET(HDRP(bp)) != GET(FTRP(bp)))
    printf("Error: header does not match footer\n");
}

void *mm_calloc (size_t nmemb, size_t size)
{
  void *ptr;
  if (heap_listp == 0){
    mm_init();
  }

  ptr = mm_malloc(nmemb*size);
  bzero(ptr, nmemb*size);


  return ptr;
}

static void freelist_insert(void *bp){
    SET_NEXT(bp, free_listp);
    SET_PREV(free_listp, bp);
    SET_PREV(bp, NULL);
    free_listp = bp;
}

static void freelist_remove(void *bp){
    if (PREV_FREE(bp)){
        SET_NEXT(PREV_FREE(bp), NEXT_FREE(bp));
    }
    else{
        free_listp = NEXT_FREE(bp);
    }
    SET_PREV(NEXT_FREE(bp), PREV_FREE(bp));
}
