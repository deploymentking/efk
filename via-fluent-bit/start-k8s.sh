#!/usr/bin/env bash

# Setting color variables
source scripts/variables-colour.sh

# Check if Minikube, kubectl and Virtualbox are installed
echo "${green}Checking pre-requisites...${reset}"
type docker >/dev/null 2>&1 || { echo >&2 "${yellow}Docker required but it's not installed.  Aborting.${reset}"; exit 1; }
type virtualbox >/dev/null 2>&1 || { echo >&2 "${yellow}VirtualBox required but it's not installed.  Aborting.${reset}"; exit 1; }
type kubectl >/dev/null 2>&1 || { echo >&2 "${yellow}kubectl required but it's not installed.  Aborting.${reset}"; exit 1; }
type minikube >/dev/null 2>&1 || { echo >&2 "${yellow}Minikube required but it's not installed.  Aborting.${reset}"; exit 1; }

# Set up variables
DASHBOARD_PORT=30000

source scripts/configure-minikube.sh

echo
echo "${green}Listing services...${reset}"
kubectl get service

echo
echo "${green}Listing pods...${reset}"
kubectl get pods
kubectl get pods --namespace default
kubectl get pods --namespace kube-system

echo
echo "${green}Launching k8s dashboard...${reset}"
minikube dashboard

echo
echo "${green}Tailing fluent-bit logs...${reset}"
kubectl logs -f --namespace=logging $(kubectl get pods --namespace=logging -l k8s-app=fluent-bit-logging -o name) -c fluent-bit
