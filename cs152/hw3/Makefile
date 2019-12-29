hw3_provided.o: hw3_provided.c hw3_provided.h
	clang -c -Wall -o hw3_provided.o hw3_provided.c

warmup3: hw3_provided.o warmup3.c warmup3_main.c warmup3.h
	clang -Wall -o warmup3 hw3_provided.o warmup3.c warmup3_main.c -lpng

hw3: hw3.h hw3.c hw3_main.c
	clang -Wall -o hw3 hw3_provided.o hw3.c hw3_main.c -lpng