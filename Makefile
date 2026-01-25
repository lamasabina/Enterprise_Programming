CC = gcc
CFLAGS = -O2 -Wall
PTHREAD = -pthread

all: bubble_seq merge_seq bubble_par merge_par

bubble_seq: src/sequential/bubble_sequential.c
	$(CC) $(CFLAGS) -o bubble_seq src/sequential/bubble_sequential.c

merge_seq: src/sequential/merge_sequential.c
	$(CC) $(CFLAGS) -o merge_seq src/sequential/merge_sequential.c

bubble_par: src/parallel/bubble_parallel.c
	$(CC) $(CFLAGS) $(PTHREAD) -o bubble_par src/parallel/bubble_parallel.c

merge_par: src/parallel/merge_parallel.c
	$(CC) $(CFLAGS) $(PTHREAD) -o merge_par src/parallel/merge_parallel.c

clean:
	rm -f bubble_seq merge_seq bubble_par merge_par

test: all
	@echo "=== Performance Test (10,000 elements) ==="
	@./bubble_seq 10000
	@./merge_seq 10000
	@./bubble_par 10000 4
	@./merge_par 10000 4
