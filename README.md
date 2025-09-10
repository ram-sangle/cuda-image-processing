# CUDA Image Processing Project

This project demonstrates GPU-accelerated image processing using native CUDA C++. It applies:

- Grayscale conversion
- Sobel edge detection

to a batch of sample images.

```

## 📁 Folder Structure

CUDA_ImageProcessingProject/ 
├── bin/ # Compiled executables 
├── data/ 
│ └── input_images/ # Sample input images 
├── images/ # Output images (grayscale and edge) 
├── lib/ # Optional helper libraries 
├── logs/ # Execution logs and terminal output 
├── src/ 
│ └── image_processing.cu # CUDA C++ source code 
├── Makefile # Build instructions 
├── run.sh # Execution script 
├── README.md # Project overview and instructions

```

## ⚙️ How to Build and Run

### 🔧 Prerequisites

- CUDA Toolkit installed
- OpenCV installed with development headers
- `nvcc` available in your system path

### 🛠️ Build

```
make
```
### 🚀 Run
```
./run.sh
```
This script will:

Execute the image processing pipeline
Save grayscale and edge-detected images in the images/ folder
Log output to logs/execution_log.txt and logs/terminal_output.txt

🖼️ Sample Input

data/input_images/sample.bmp: A sample image used for testing

📸 Output

images/gray.bmp: Grayscale version of the input
images/edge.bmp: Edge-detected version using Sobel operator

📚 Notes

The CUDA kernels are optimized for 8-bit RGB input and single-channel output.
The Sobel operator uses a simple gradient magnitude approximation.
You can replace sample.bmp with any other .bmp image for testing.

📄 License

This project is released under the MIT License.
