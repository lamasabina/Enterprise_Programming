#!/bin/bash

echo "======================================================"
echo "  COMPREHENSIVE SORTING PERFORMANCE TEST"
echo "======================================================"
echo "Testing all array sizes with 10 runs each..."
echo ""

# Array sizes to test
SIZES=(5000 10000 50000 100000 500000)
THREADS=4

# Create/clear results file
echo "Algorithm,Size,Threads,Time_ms,Run" > results_complete.csv

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "BUBBLE SORT SEQUENTIAL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        result=$(./bubble_seq $size 2>&1 | grep "Sequential Bubble Sort" | awk '{print $4}')
        echo "Bubble-Seq,$size,1,$result,$run" >> results_complete.csv
        echo "  Run $run: $result"
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "BUBBLE SORT PARALLEL (4 threads)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        result=$(./bubble_par $size $THREADS 2>&1 | grep "Parallel Bubble Sort" | awk '{print $5}')
        echo "Bubble-Par,$size,$THREADS,$result,$run" >> results_complete.csv
        echo "  Run $run: $result"
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MERGE SORT SEQUENTIAL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        result=$(./merge_seq $size 2>&1 | grep "Sequential Merge Sort" | awk '{print $4}')
        echo "Merge-Seq,$size,1,$result,$run" >> results_complete.csv
        echo "  Run $run: $result"
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MERGE SORT PARALLEL (4 threads)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        result=$(./merge_par $size $THREADS 2>&1 | grep "Parallel Merge Sort" | awk '{print $5}')
        echo "Merge-Par,$size,$THREADS,$result,$run" >> results_complete.csv
        echo "  Run $run: $result"
    done
done

echo ""
echo "======================================================"
echo "✅ ALL TESTS COMPLETE!"
echo "======================================================"
echo ""
echo "Results saved to: results_complete.csv"
echo "Total entries: $(wc -l < results_complete.csv)"
echo ""
echo "Preview of results:"
head -20 results_complete.csv
