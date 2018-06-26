#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/../helpers/common.sh

cd ../../

kubectl create namespace database

kubectl apply -f ./via-k8s/config/mysql.yaml

echo
echo "${green}Successfully launched MySQL container...${reset}"
