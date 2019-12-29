#include <stdio.h>
#include <stdlib.h>
#include "hw3_provided.h"
#include "hw3.h"

int main()
{
    // hides "testhid1.png" in "testref1.png" and stores the
    // encoded image in "testenc1.png"
    // then decodes the "testenc1.png" and stores the extracted
    // image in "testhid1.png"
    encode("testref1.png", "testhid1.png", "testenc1.png");
    decode("testenc1.png", "testhid1.png");

    // hides "uchicago.png" in "testref1.png" and stores the
    // encoded image in "testhidbad1.png"
    // then decodes the "testhidbad1.png" and stores the extracted
    // image in "uchicago.png"
    encode("testref1.png", "uchicago.png", "testhidbad1.png");
    decode("testhidbad1.png", "uchicago.png");
}