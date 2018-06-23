#!/usr/bin/env bash

function setupMinikube {
    # Delete Minikube VM
    echo
    echo "${green}Deleting Minikube...${reset}"
    minikube delete

    # Start up minikube and set Docker registry context
    echo
    echo "${green}Starting Minikube...${reset}"
    minikube start
    minikube status

    # Set minikube configuration
    echo
    echo "${green}Configuring Minikube...${reset}"
    minikube config set cpus 2
    minikube config set memory 2048
    minikube config set disk-size 10g
    minikube addons enable heapster
    minikube config view

    # Set up variables
    dashboard_port=30000
    minikube_ip=$(minikube ip)
    echo
    echo "${green}Waiting for Minikube to start up on $minikube_ip:$dashboard_port...${reset}"
    until $(curl --output /dev/null --silent --head --fail http://${minikube_ip}:${dashboard_port}); do
        printf '.'
        sleep 5
    done
    echo

    echo
    echo "${green}Setting the Docker Registry to point to Minikube for this terminal window...${reset}"
    eval $(minikube docker-env)
}
