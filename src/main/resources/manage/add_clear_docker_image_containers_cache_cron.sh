#!/bin/bash

#定时清除docker的垃圾数据：镜像、容器等
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/docker image prune -f && usr/bin/docker container prune -f  >> /var/log/clear_docker_prune_cron.log 2>&1" ) | crontab -
