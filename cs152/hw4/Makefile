hw4_provided.o: hw4_provided.c hw4_provided.h
	clang -c -Wall -o hw4_provided.o hw4_provided.c

warmup4_provided.o: warmup4_provided.c warmup4_provided.h
	clang -c -Wall -o warmup4_provided.o warmup4_provided.c -lpng

warmup4: warmup4.h warmup4.c warmup4_main.c
	clang -Wall -o warmup4 warmup4_provided.o warmup4.c warmup4_main.c -lpng

hw4: hw4.h hw4.c hw4_main.c
	clang -Wall -o hw4 hw4_provided.o hw4.c hw4_main.c