#include <cstdio>
#include <cuda_runtime.h>

__global__ void add_one(int *value) {
  value[0] += 1;
}

int main() {
  int host_value = 41;
  int *device_value = nullptr;

  cudaError_t err = cudaMalloc(&device_value, sizeof(int));
  if (err != cudaSuccess) {
    std::fprintf(stderr, "cudaMalloc failed: %s\n", cudaGetErrorString(err));
    return 1;
  }

  err = cudaMemcpy(device_value, &host_value, sizeof(int), cudaMemcpyHostToDevice);
  if (err != cudaSuccess) {
    std::fprintf(stderr, "cudaMemcpy H2D failed: %s\n", cudaGetErrorString(err));
    cudaFree(device_value);
    return 1;
  }

  add_one<<<1, 1>>>(device_value);
  err = cudaDeviceSynchronize();
  if (err != cudaSuccess) {
    std::fprintf(stderr, "kernel execution failed: %s\n", cudaGetErrorString(err));
    cudaFree(device_value);
    return 1;
  }

  err = cudaMemcpy(&host_value, device_value, sizeof(int), cudaMemcpyDeviceToHost);
  if (err != cudaSuccess) {
    std::fprintf(stderr, "cudaMemcpy D2H failed: %s\n", cudaGetErrorString(err));
    cudaFree(device_value);
    return 1;
  }

  cudaDeviceProp prop{};
  err = cudaGetDeviceProperties(&prop, 0);
  if (err != cudaSuccess) {
    std::fprintf(stderr, "cudaGetDeviceProperties failed: %s\n", cudaGetErrorString(err));
    cudaFree(device_value);
    return 1;
  }

  std::printf("device=%s compute=%d.%d result=%d\n", prop.name, prop.major, prop.minor, host_value);
  cudaFree(device_value);
  return host_value == 42 ? 0 : 2;
}
