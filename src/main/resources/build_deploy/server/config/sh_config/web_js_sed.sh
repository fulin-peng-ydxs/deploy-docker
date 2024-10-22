#!/bin/bash

# Check if a directory path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

# Use the provided directory path
directory_path="$1"

# Find the largest file in the directory
largest_file=$(find "$directory_path" -type f -exec du -b {} + | sort -n | tail -n 1 | cut -f2)

if [ -z "$largest_file" ]; then
    echo "No files found in the directory."
    exit 1
fi

# Replace content in the largest file
sed -i 's:/\*\*:/*:g' "$largest_file"

echo "Replacement complete in $largest_file"
