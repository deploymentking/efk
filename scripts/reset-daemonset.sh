#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)

source ${directory}/helpers/common.sh

echo
echo "${green}Deleting existing config setup...${reset}"
kubectl delete ds fluent-bit --namespace=logging
kubectl delete configmap fluent-bit-config --namespace=logging

sleep 5
work_dir=../via-k8s/config

echo
echo "${green}Recreating config setup...${reset}"
kubectl apply -f ${work_dir}/fluent-bit-configmap.yaml --namespace=logging
kubectl apply -f ${work_dir}/fluent-bit-ds-minikube.yaml --namespace=logging

echo
echo "${green}Tailing fluent-bit logs...${reset}"
continueAfterContainerCreated logging k8s-app=fluent-bit-logging
kubectl logs -f --namespace=logging $(kubectl get pods --namespace=logging -l k8s-app=fluent-bit-logging -o name) -c fluent-bit
