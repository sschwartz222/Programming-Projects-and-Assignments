 * inputs:
 *      unsigned int - we will calculate n!
 * outputs:
 *      unsigned long int - n!
 */
unsigned long int fact(unsigned int n)
{
  // base case
  if (n==0)
  {
    return 1;
  }
  else
  {
    // call the recursive case
    int smaller_result = fact(n-1);
    // modify the result from recursive case and return our result
    return n * smaller_result;
  }
}

^[:wq
^?^[[3~^[[3~^?^[[3~^?^?^[[3~^?

