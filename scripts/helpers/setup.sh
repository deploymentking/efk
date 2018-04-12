#!/usr/bin/env bash

function setupMinikube {
    # Delete Minikube VM
    echo
    echo "${green}Deleting Minikube...${reset}"
    minikube delete

    # Set minikube configuration
    echo
    echo "${green}Configuring Minikube...${reset}"
    minikube config set cpus 2
    minikube config set memory 2048
    minikube config set disk-size 10g
    minikube addons disable efk
    minikube addons enable heapster
    minikube config view

    # Start up minikube and set Docker registry context
    echo
    echo "${green}Starting Minikube...${reset}"
    minikube start
    minikube status

    # Set up variables
    DASHBOARD_PORT=30000
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
}
