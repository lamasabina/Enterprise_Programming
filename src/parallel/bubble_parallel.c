#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

typedef struct {
    int *array;
    int n;
    int thread_id;
    int num_threads;
    pthread_mutex_t *mutex;
    pthread_cond_t *cond;
    int *phase_counter;
} ThreadData;

void compare_and_swap(int i, int j, int arr[]) {
    if (arr[i] > arr[j]) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

void custom_barrier(ThreadData *data) {
    pthread_mutex_lock(data->mutex);
    (*data->phase_counter)++;
    
    if (*data->phase_counter == data->num_threads) {
        *data->phase_counter = 0;
        pthread_cond_broadcast(data->cond);
    } else {
        pthread_cond_wait(data->cond, data->mutex);
    }
    pthread_mutex_unlock(data->mutex);
}

void *parallel_bubble_thread(void *arg) {
    ThreadData *data = (ThreadData *)arg;
    for (int phase = 0; phase < data->n; phase++) {
        int start = data->thread_id * (data->n / data->num_threads);
        int end = (data->thread_id == data->num_threads - 1) ? 
                  data->n : (data->thread_id + 1) * (data->n / data->num_threads);
        
        if (phase % 2 == 0) {
            for (int i = start; i < end; i += 2) 
                if (i + 1 < data->n) compare_and_swap(i, i + 1, data->array);
        } else {
            int i = (start % 2 == 0) ? start + 1 : start;
            for (; i < end; i += 2) 
                if (i + 1 < data->n) compare_and_swap(i, i + 1, data->array);
        }
        custom_barrier(data);
    }
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
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    int phase_counter = 0;
    
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    
    for (int i = 0; i < thread_count; i++) {
        thread_data[i].array = array;
        thread_data[i].n = n;
        thread_data[i].thread_id = i;
        thread_data[i].num_threads = thread_count;
        thread_data[i].mutex = &mutex;
        thread_data[i].cond = &cond;
        thread_data[i].phase_counter = &phase_counter;
        pthread_create(&threads[i], NULL, parallel_bubble_thread, &thread_data[i]);
    }
    
    for (int i = 0; i < thread_count; i++) pthread_join(threads[i], NULL);
    
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
    
    double time_taken = (end.tv_sec - start.tv_sec) * 1000.0 + 
                       (end.tv_nsec - start.tv_nsec) / 1000000.0;
    
    printf("Parallel Bubble Sort (%d threads): %.2f ms\n", thread_count, time_taken);
    free(array);
    return 0;
}
