#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <堆栈名>"
    exit 1
fi

docker stack rm $1