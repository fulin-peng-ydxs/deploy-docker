#!/bin/bash

SERVICE_NAME=$1
SERVICE_NAME_REAL=${2:-$SERVICE_NAME}
REMOTE_SERVER=8.138.127.55
REMOTE_DIRECTORY=/root

if [ -z "$SERVICE_NAME" ]; then 
   echo "服务名为空"
   exit 1
fi

IMAGE_NAME=$(docker inspect --format='{{.Spec.TaskTemplate.ContainerSpec.Image}}' $SERVICE_NAME)
IMAGE_NAME=$(echo "$IMAGE_NAME" | sed 's/@.*//')
if [ -z "$IMAGE_NAME" ]; then
   echo "没有获取到服务镜像"
   exit 1
fi
echo "=====拉取服务镜像：$SERVICE_NAME---$IMAGE_NAME======"
docker pull $IMAGE_NAME

if [ $? -ne 0 ]; then
   exit 1
fi

IMAGE_FILE="$SERVICE_NAME_REAL.tar.gz"
echo "=====保存服务镜像：$IMAGE_FILE====="
docker save $IMAGE_NAME | gzip -c > $IMAGE_FILE

if [ $? -ne 0 ]; then
   exit 1
fi

echo "=====发送服务镜像包：$REMOTE_SERVER:$REMOTE_DIRECTORY======"
scp $IMAGE_FILE $REMOTE_SERVER:$REMOTE_DIRECTORY

if [ $? -ne 0 ]; then
   exit 1
fi

echo "=====删除服务镜像包：$IMAGE_FILE======"
rm -f $IMAGE_FILE

if [ $? -ne 0 ]; then
   exit 1
fi

echo "=====更新服务======"
ssh $REMOTE_SERVER "cd $REMOTE_DIRECTORY && /usr/bin/docker load -i $IMAGE_FILE  && /usr/bin/docker  service update --force --image $IMAGE_NAME $SERVICE_NAME_REAL && rm -f $IMAGE_FILE"
