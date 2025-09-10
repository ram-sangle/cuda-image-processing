#include <iostream>
#include <opencv2/opencv.hpp>
#include <cuda_runtime.h>

__global__ void rgb2gray_kernel(unsigned char* input, unsigned char* output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    if (x < width && y < height) {
        int idx = (y * width + x) * 3;
        unsigned char r = input[idx];
        unsigned char g = input[idx + 1];
        unsigned char b = input[idx + 2];
        output[y * width + x] = static_cast<unsigned char>(0.299f * r + 0.587f * g + 0.114f * b);
    }
}

__global__ void sobel_kernel(unsigned char* input, unsigned char* output, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
        int idx = y * width + x;
        int gx = -input[(y - 1) * width + (x - 1)] - 2 * input[y * width + (x - 1)] - input[(y + 1) * width + (x - 1)]
               + input[(y - 1) * width + (x + 1)] + 2 * input[y * width + (x + 1)] + input[(y + 1) * width + (x + 1)];
        int gy = -input[(y - 1) * width + (x - 1)] - 2 * input[(y - 1) * width + x] - input[(y - 1) * width + (x + 1)]
               + input[(y + 1) * width + (x - 1)] + 2 * input[(y + 1) * width + x] + input[(y + 1) * width + (x + 1)];
        output[idx] = min(255, abs(gx) + abs(gy));
    }
}

int main() {
    std::string input_path = "input_images/eiffle-tower.bmp";
    std::string gray_path = "images/gray-eiffle-tower.bmp";
    std::string edge_path = "images/edge-eiffle-tower.bmp";

    cv::Mat input_img = cv::imread(input_path, cv::IMREAD_COLOR);
    int width = input_img.cols;
    int height = input_img.rows;

    unsigned char *d_input, *d_gray, *d_edge;
    size_t rgb_size = width * height * 3;
    size_t gray_size = width * height;

    cudaMalloc(&d_input, rgb_size);
    cudaMalloc(&d_gray, gray_size);
    cudaMalloc(&d_edge, gray_size);

    cudaMemcpy(d_input, input_img.data, rgb_size, cudaMemcpyHostToDevice);

    dim3 block(16, 16);
    dim3 grid((width + block.x - 1) / block.x, (height + block.y - 1) / block.y);

    rgb2gray_kernel<<<grid, block>>>(d_input, d_gray, width, height);
    sobel_kernel<<<grid, block>>>(d_gray, d_edge, width, height);

    cv::Mat gray_img(height, width, CV_8UC1);
    cv::Mat edge_img(height, width, CV_8UC1);
    cudaMemcpy(gray_img.data, d_gray, gray_size, cudaMemcpyDeviceToHost);
    cudaMemcpy(edge_img.data, d_edge, gray_size, cudaMemcpyDeviceToHost);

    cv::imwrite(gray_path, gray_img);
    cv::imwrite(edge_path, edge_img);

    cudaFree(d_input);
    cudaFree(d_gray);
    cudaFree(d_edge);

    std::cout << "Image processing completed using CUDA." << std::endl;
    return 0;
}
