#!/bin/bash
echo "=== Sorting Algorithm Test ==="
echo ""
echo "Testing with 20,000 elements:"
echo "------------------------------"
make clean
make
echo ""
./bubble_seq 20000
./merge_seq 20000
./bubble_par 20000 4
./merge_par 20000 4
