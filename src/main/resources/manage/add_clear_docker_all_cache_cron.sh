#!/bin/bash

#定时清除docker的垃圾数据：镜像、容器等
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/docker system prune -af >> /var/log/clear_docker_prune_cron.log 2>&1") | crontab -

#这个命令行可以分解为以下几个部分：
#
#(crontab -l 2>/dev/null; echo "0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1"):
#
#这是一对圆括号，将其内部的两个命令结合成一个子 Shell。子 Shell 中的内容会在执行前先组合在一起，形成一个整体。
#crontab -l 2>/dev/null:
#
#crontab -l: 列出当前用户的所有 Cron 任务。如果没有任何任务，通常会显示错误消息。
#2>/dev/null: 将错误输出重定向到 /dev/null，即忽略掉错误消息。这样做是为了避免当没有 Cron 任务时产生的错误信息。
#;:
#
#分号用来分隔两个命令，表示先执行前面的命令，再执行后面的命令。
#echo "0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1":
#
#echo 命令用于输出一个字符串。
#"0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1" 是要添加到 Crontab 中的具体任务计划。
#0 2 * * *: 表示每天凌晨 2 点执行任务。
#/path/to/docker-cleanup.sh: 是要执行的脚本路径。
#>> /var/log/docker-cleanup.log: 将标准输出重定向追加到日志文件 /var/log/docker-cleanup.log 中。
#2>&1: 将标准错误输出重定向到标准输出，即将错误信息也写入同一个日志文件。
#| crontab -:
#
#| 是管道符号，将前面子 Shell 的输出结果作为输入传递给 crontab 命令。
#crontab - 表示将标准输入中的内容替换为当前用户的 Crontab 配置。这里的 - 是指标准输入的占位符。


#整个命令行的执行过程如下：
#
#crontab -l 2>/dev/null
#列出当前用户的所有 Cron 任务，并将结果输出；如果没有任务，不显示错误信息。
#
#echo "0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1"
#输出一个包含新任务计划的字符串。
#
#合并输出
#子 Shell 中的两个命令的输出被组合成一个完整的 Cron 列表，包含了当前用户已有的任务以及新的任务。
#
#管道传输
#通过管道符，将子 Shell 输出的整个任务列表传递给 crontab - 命令。
#
#更新 Crontab
#crontab - 命令接收到完整的任务列表后，将其写入到当前用户的 Crontab 中，替换掉之前的配置。

#示例场景:

#假设当前用户原有的 Crontab 是：
#0 0 * * * /path/to/some-script.sh

#执行命令后：
#(crontab -l 2>/dev/null; echo "0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1") | crontab -
#新的 Crontab 内容将是：
#0 0 * * * /path/to/some-script.sh
#0 2 * * * /path/to/docker-cleanup.sh >> /var/log/docker-cleanup.log 2>&1