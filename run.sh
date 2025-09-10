#!/bin/bash

# Build the project
make

# Create output and log directories if they don't exist
mkdir -p images
mkdir -p logs

# Initialize logs
echo "Batch image processing started." > logs/execution_log.txt
echo "Terminal output:" > logs/terminal_output.txt

# Process each .bmp image in the input directory
for input_file in data/input_images/*.bmp; do
    filename=$(basename "$input_file")
    base="${filename%.*}"
    gray_output="images/${base}_gray.bmp"
    edge_output="images/${base}_edge.bmp"

    echo "Processing $filename..." >> logs/execution_log.txt
    ./bin/image_processing "$input_file" "$gray_output" "$edge_output" >> logs/terminal_output.txt 2>&1
done

echo "Batch image processing completed." >> logs/execution_log.txt
