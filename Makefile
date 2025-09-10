all:
        nvcc -o bin/image_processing src/image_processing.cu `pkg-config --cflags --libs opencv4`
