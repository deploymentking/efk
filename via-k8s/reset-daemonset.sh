#!/usr/bin/env bash

echo "${green}Deleting existing config setup...${reset}"
kubectl delete ds fluent-bit --namespace=logging
kubectl delete configmap fluent-bit-config --namespace=logging
sleep 5
kubectl apply -f ./config/fluent-bit-configmap.yaml --namespace=logging
sleep 5
kubectl apply -f ./config/fluent-bit-ds-minikube.yaml --namespace=logging
echo
echo "${green}Tailing fluent-bit logs...${reset}"
kubectl logs -f --namespace=logging $(kubectl get pods --namespace=logging -l k8s-app=fluent-bit-logging -o name) -c fluent-bit
