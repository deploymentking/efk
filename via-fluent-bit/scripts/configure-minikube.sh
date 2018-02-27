#!/usr/bin/env bash

# Delete Minikube VM
echo "${green}Deleting Minikube...${reset}"
minikube delete

# Set minikube configuration
echo
echo "${green}Configuring Minikube...${reset}"
minikube config set cpus 2
minikube config set memory 2048
minikube config set disk-size 10g
#minikube addons enable efk
minikube config view

# Start up minikube and set Docker registry context
echo
echo "${green}Starting Minikube...${reset}"
minikube start
minikube status

MINIKUBE_IP=$(minikube ip)
echo
echo "${green}Waiting for Minikube to start up on $MINIKUBE_IP:$DASHBOARD_PORT...${reset}"
until $(curl --output /dev/null --silent --head --fail http://${MINIKUBE_IP}:${DASHBOARD_PORT}); do
    printf '.'
    sleep 5
done
echo

echo
echo "${green}Setting the Docker Registry to point to Minikube for this terminal window...${reset}"
eval $(minikube docker-env)

echo
echo "${green}Creating the namespace and cluster setup...${reset}"
kubectl create namespace logging
kubectl config set-context $(kubectl config current-context) --namespace=logging

# Fluent Bit must be deployed as a DaemonSet, so on that way it will be available on every node of your Kubernetes cluster.
# To get started run the following commands to create the namespace, service account and role setup:
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-service-account.yaml
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role.yaml
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/fluent-bit-role-binding.yaml
# The next step is to create a ConfigMap that will be used by our Fluent Bit DaemonSet:
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/output/elasticsearch/fluent-bit-configmap.yaml
# Fluent Bit to Elasticsearch on Minikube
kubectl create -f https://raw.githubusercontent.com/fluent/fluent-bit-kubernetes-logging/master/output/elasticsearch/fluent-bit-ds-minikube.yaml
