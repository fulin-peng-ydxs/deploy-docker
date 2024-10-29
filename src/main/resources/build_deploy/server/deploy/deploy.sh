#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <堆栈文件> <堆栈名>"
    exit 1
fi

docker stack deploy --compose-file $1 $2