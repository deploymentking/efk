#!/usr/bin/env bash

echo
echo "${green}Creating the redis namespace and cluster setup...${reset}"
kubectl create namespace redis
kubectl config set-context $(kubectl config current-context) --namespace=redis

echo
echo "${green}Configuring Redis cluster...${reset}"
kubectl create -f ./config/redis-master.yaml

echo
echo "${green}Launching Redis master...${reset}"
continueAfterContainerCreated redis name=redis

kubectl create -f ./config/redis-sentinel-service.yaml
kubectl create -f ./config/redis-controller.yaml
kubectl create -f ./config/redis-sentinel-controller.yaml

kubectl scale rc redis --replicas=3
kubectl scale rc redis-sentinel --replicas=3

#kubectl delete pods redis-master
