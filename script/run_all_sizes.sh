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

# Function to extract time from output
extract_time() {
    local output="$1"
    local pattern="$2"
    
    # Extract line containing the pattern
    local line=$(echo "$output" | grep "$pattern")
    
    if [ -z "$line" ]; then
        echo "ERROR: Pattern '$pattern' not found"
        echo "Full output: $output"
        return 1
    fi
    
    # Extract the floating point number using regex
    local time=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+')
    
    if [ -z "$time" ]; then
        echo "ERROR: No time value found in line: $line"
        return 1
    fi
    
    echo "$time"
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "BUBBLE SORT SEQUENTIAL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        output=$(./bubble_seq $size 2>&1)
        result=$(extract_time "$output" "Sequential Bubble Sort")
        
        if [ $? -eq 0 ]; then
            echo "Bubble-Seq,$size,1,$result,$run" >> results_complete.csv
            echo "  Run $run: $result ms"
        else
            echo "Bubble-Seq,$size,1,ERROR,$run" >> results_complete.csv
            echo "  Run $run: ERROR - $result"
        fi
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "BUBBLE SORT PARALLEL (4 threads)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        output=$(./bubble_par $size $THREADS 2>&1)
        result=$(extract_time "$output" "Parallel Bubble Sort")
        
        if [ $? -eq 0 ]; then
            echo "Bubble-Par,$size,$THREADS,$result,$run" >> results_complete.csv
            echo "  Run $run: $result ms"
        else
            echo "Bubble-Par,$size,$THREADS,ERROR,$run" >> results_complete.csv
            echo "  Run $run: ERROR - $result"
        fi
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MERGE SORT SEQUENTIAL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        output=$(./merge_seq $size 2>&1)
        result=$(extract_time "$output" "Sequential Merge Sort")
        
        if [ $? -eq 0 ]; then
            echo "Merge-Seq,$size,1,$result,$run" >> results_complete.csv
            echo "  Run $run: $result ms"
        else
            echo "Merge-Seq,$size,1,ERROR,$run" >> results_complete.csv
            echo "  Run $run: ERROR - $result"
        fi
    done
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "MERGE SORT PARALLEL (4 threads)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
for size in "${SIZES[@]}"; do
    echo "Size: $size elements"
    for run in {1..10}; do
        output=$(./merge_par $size $THREADS 2>&1)
        result=$(extract_time "$output" "Parallel Merge Sort")
        
        if [ $? -eq 0 ]; then
            echo "Merge-Par,$size,$THREADS,$result,$run" >> results_complete.csv
            echo "  Run $run: $result ms"
        else
            echo "Merge-Par,$size,$THREADS,ERROR,$run" >> results_complete.csv
            echo "  Run $run: ERROR - $result"
        fi
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
echo "Preview of valid results:"
grep -v "ERROR" results_complete.csv | head -20

# Generate summary statistics
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY STATISTICS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Valid measurements per algorithm:"
echo "Bubble-Seq: $(grep -c "Bubble-Seq,.*,[0-9]" results_complete.csv)"
echo "Bubble-Par: $(grep -c "Bubble-Par,.*,[0-9]" results_complete.csv)"
echo "Merge-Seq:  $(grep -c "Merge-Seq,.*,[0-9]" results_complete.csv)"
echo "Merge-Par:  $(grep -c "Merge-Par,.*,[0-9]" results_complete.csv)"
echo "Total valid: $(grep -v "ERROR" results_complete.csv | wc -l)"