#!/bin/bash
docker build  --build-arg WAR_FILE=${1:-enforce-client.war} -t "reg.int.it2000.com.cn/com.aifa.mins/enforce/xhd:${2:-latest}" .
