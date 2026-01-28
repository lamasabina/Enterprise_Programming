#!/bin/bash
echo "=== Sorting Algorithm Test ==="
echo ""
echo "Testing with 10,000 elements:"
echo "------------------------------"
make clean
make
echo ""
./bubble_seq 10000
./merge_seq 10000
./bubble_par 10000 4
./merge_par 10000 4
