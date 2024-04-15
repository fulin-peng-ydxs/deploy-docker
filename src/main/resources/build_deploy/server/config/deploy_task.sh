#!/bin/bash

git_url=${5:-git@gitlab.int.it2000.com.cn:gxts/flowable-task.git}
build_root=$(dirname "$(readlink -f "$0")")
cd "${build_root}" || exit
build_path=${build_root}/$( echo $git_url | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}')
echo "=========删除旧构建源:${build_path}==========="
rm -rf "${build_path}"

#拉取仓库
git_branch=${1:-master}
echo "=========拉取新构建源:${git_branch}-${git_url}==========="
git clone -b "${git_branch}" $git_url

if [ $? -ne 0 ]; then
  exit 1
fi

#执行构建
cd "${build_path}" || exit
groupId=$(awk -F'[<>]' '/<groupId>/ {print $3; exit}' pom.xml)
artifactId=$(awk -F'[<>]' '/<artifactId>/ {print $3; exit}' pom.xml)
version=$(awk -F'[<>]' '/<version>/ {print $3; exit}' pom.xml)
jar_file=target/${artifactId}-${version}.jar
echo "=========jar构建:${jar_file}==========="
mvn clean package spring-boot:repackage -Dmaven.test.skip=true

if [ $? -ne 0 ]; then
  exit 1
fi

#构建镜像
image_repository=${2:-reg.int.it2000.com.cn}
if [ "$4" = "prod" ]; then
    echo "构建生产版本镜像:${version}"
    image_version=${version}
else
    echo "构建测试版本镜像:latest"
    image_version=latest
fi
image_name=${image_repository}/${groupId}/${artifactId}:${image_version}
echo "=========镜像构建:${image_name}==========="
docker build  --build-arg JAR_FILE="${jar_file}"  -t "${image_name}" .

if [ $? -ne 0 ]; then
  exit 1
fi
#推送镜像
echo "=========推送镜像:${image_repository}=========="
docker push "${image_name}"

if [ $? -ne 0 ]; then
  exit 1
fi

#更新服务
service_name=${3:-${groupId}_${artifactId}}
echo "=========更新服务:${service_name}========="
docker service update --force  --image "${image_name}" "${service_name}"