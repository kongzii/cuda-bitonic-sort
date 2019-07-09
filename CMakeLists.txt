cmake_minimum_required(VERSION 3.10)
project(CBMS)

set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -O2 -ccbin gcc-6)

find_package(CUDA REQUIRED)

cuda_add_executable(CBMS src/main.cu src/utils.h)

