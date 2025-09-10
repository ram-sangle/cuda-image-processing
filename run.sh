#!/bin/bash

# Build the project
make

# Run the compiled binary
./bin/image_processing > logs/terminal_output.txt

# Log completion
echo "Execution completed." >> logs/execution_log.txt
