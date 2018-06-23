#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh
source ${directory}/helpers/setup.sh
source ${directory}/helpers/installers.sh

checkPreRequisites

setupMinikube

installFluentBit

echo
echo "${green}Launching k8s dashboard...${reset}"
minikube dashboard

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
echo "${green}Launching grafana dashboard...${reset}"
continueAfterContainerCreated kube-system k8s-app=influx-grafana
minikube addons open heapster
