#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

typedef struct {
    int *array;
    int left;
    int right;
} ThreadData;

void merge(int arr[], int left, int mid, int right) {
    int i, j, k;
    int n1 = mid - left + 1;
    int n2 = right - mid;
    int *L = malloc(n1 * sizeof(int));
    int *R = malloc(n2 * sizeof(int));
    
    for (i = 0; i < n1; i++) L[i] = arr[left + i];
    for (j = 0; j < n2; j++) R[j] = arr[mid + 1 + j];
    
    i = 0; j = 0; k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) arr[k++] = L[i++];
        else arr[k++] = R[j++];
    }
    while (i < n1) arr[k++] = L[i++];
    while (j < n2) arr[k++] = R[j++];
    
    free(L); free(R);
}

void merge_sort_sequential(int arr[], int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort_sequential(arr, left, mid);
        merge_sort_sequential(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

void *merge_sort_thread(void *arg) {
    ThreadData *args = (ThreadData *)arg;
    merge_sort_sequential(args->array, args->left, args->right);
    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: %s <array_size> <thread_count>\n", argv[0]);
        return 1;
    }
    
    int n = atoi(argv[1]), thread_count = atoi(argv[2]);
    int *array = malloc(n * sizeof(int));
    srand(time(NULL));
    
    for (int i = 0; i < n; i++) array[i] = rand() % 1000000;
    
    pthread_t threads[thread_count];
    ThreadData thread_data[thread_count];
    int segment_size = n / thread_count;
    
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    
    for (int i = 0; i < thread_count; i++) {
        thread_data[i].array = array;
        thread_data[i].left = i * segment_size;
        thread_data[i].right = (i == thread_count - 1) ? n - 1 : 
                               (i + 1) * segment_size - 1;
        pthread_create(&threads[i], NULL, merge_sort_thread, &thread_data[i]);
    }
    
    for (int i = 0; i < thread_count; i++) pthread_join(threads[i], NULL);
    
    while (thread_count > 1) {
        int new_threads = thread_count / 2;
        segment_size = n / thread_count;
        
        for (int i = 0; i < new_threads; i++) {
            int left = i * 2 * segment_size;
            int mid = left + segment_size - 1;
            int right = (i == new_threads - 1 && thread_count % 2 == 0) ? 
                       n - 1 : left + 2 * segment_size - 1;
            if (mid < right) merge(array, left, mid, right);
        }
        thread_count = new_threads;
    }
    
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double time_taken = (end.tv_sec - start.tv_sec) * 1000.0 + 
                       (end.tv_nsec - start.tv_nsec) / 1000000.0;
    
    printf("Parallel Merge Sort (%d threads): %.2f ms\n", atoi(argv[2]), time_taken);
    free(array);
    return 0;
}
