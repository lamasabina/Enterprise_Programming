#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void bubble_sort(int arr[], int n) {
    int i, j, temp, swapped;
    for (i = 0; i < n - 1; i++) {
        swapped = 0;
        for (j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = 1;
            }
        }
        if (!swapped) break;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <array_size>\n", argv[0]);
        return 1;
    }
    
    int n = atoi(argv[1]);
    int *arr = malloc(n * sizeof(int));
    srand(time(NULL));
    
    for (int i = 0; i < n; i++) arr[i] = rand() % 1000000;
    
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    bubble_sort(arr, n);
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double time_taken = (end.tv_sec - start.tv_sec) * 1000.0 + 
                       (end.tv_nsec - start.tv_nsec) / 1000000.0;
    
    printf("Sequential Bubble Sort: %.2f ms\n", time_taken);
    free(arr);
    return 0;
}
