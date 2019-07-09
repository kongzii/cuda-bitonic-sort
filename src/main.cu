//
// Created by peter on 07/07/19.
//

#include <iostream>
#include <vector>
#include <algorithm>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "utils.h"

__global__ void bitonic_sort_kernel(int *values, int j, int k) {
    unsigned  int i = threadIdx.x + blockDim.x * blockIdx.x;
    unsigned int ixj = i ^ j;

    if ((ixj) > i) {
        if ((i & k) == 0) {
            /* Sort ascending */

            if (values[i] > values[ixj]) {
                SWAP_INT(values[i], values[ixj]);
            }
        }

        if ((i & k) != 0) {
            /* Sort descending */

            if (values[i] < values[ixj]) {
                SWAP_INT(values[i], values[ixj]);
            }
        }
    }
}

void bitonic_sort(int *values, int size) {
    int threads = std::min(size, 512);
    int blocks = size / threads;

    std::cout << "Threads: " << threads << std::endl
              << "Blocks: " << blocks << std::endl
              << "Size: " << size << std::endl;


    int *dev_values;
    size_t dev_size = size * sizeof(int);

    cudaMalloc((void **) &dev_values, dev_size);
    cudaMemcpy(dev_values, values, dev_size, cudaMemcpyHostToDevice);

    dim3 blocks_dim(blocks, 1);
    dim3 threads_dim(threads, 1);

    for (int i = 2; i <= size; i *= 2) {
        for (int j = i >> 1; j > 0; j /= 2) {
            bitonic_sort_kernel <<< blocks_dim, threads_dim, dev_size >>> (dev_values, j, i);
        }
    }

    cudaMemcpy(values, dev_values, dev_size, cudaMemcpyDeviceToHost);
    cudaFree(dev_values);
}

int main(int argc, char *argv[]) {
    // std::vector<int> elements = {3, 5, 8, 9, 7, 4, 2, 1};
    std::vector<int> elements = generate(1024, 0, 10000);

    // Check if size is power of two

    if (!is_power_of_two(elements.size())) {
        EXIT("Vector does not contain power of two n. of elements")
    }

    // CUDA sort

    int cuda_sorted[elements.size()];
    std::copy(elements.begin(), elements.end(), cuda_sorted);

    bitonic_sort(cuda_sorted, elements.size());

    // STD sort

    auto std_sorted = elements;

    std::sort(std_sorted.begin(), std_sorted.end());

    // Compare

    print(elements);
    print(cuda_sorted, elements.size());
    print(std_sorted);

    if (!compare(std_sorted, cuda_sorted)) {
        EXIT("CUDA and STD sorted does not match")
    } else {
        std::cout << "CUDA and STD sorts matched" << std::endl;
    }
}