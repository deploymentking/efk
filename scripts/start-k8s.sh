#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
source ${DIRECTORY}/helpers/common.sh
source ${DIRECTORY}/helpers/setup.sh
source ${DIRECTORY}/helpers/installers.sh

checkPreRequisites

setupMinikube

installFluentBit

installApache

installRedis

echo
echo "${green}Listing services...${reset}"
kubectl get service

echo
echo "${green}Listing pods...${reset}"
kubectl get pods --namespace default
kubectl get pods --namespace kube-system
kubectl get pods --namespace logging
kubectl get pods --namespace redis
kubectl get pods --namespace webserver

echo
echo "${green}Launching k8s dashboard...${reset}"
minikube dashboard

echo
echo "${green}Launching grafana dashboard...${reset}"
continueAfterContainerCreated kube-system k8s-app=influx-grafana
minikube addons open heapster

echo
echo "${green}Tailing fluent-bit logs...${reset}"
continueAfterContainerCreated logging k8s-app=fluent-bit-logging
kubectl logs -f --namespace=logging $(kubectl get pods --namespace=logging -l k8s-app=fluent-bit-logging -o name) -c fluent-bit
