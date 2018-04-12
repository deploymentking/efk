#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function checkPreRequisites {
    # Check if Minikube, kubectl and Virtualbox are installed
    echo
    echo "${green}Checking pre-requisites...${reset}"
    type docker >/dev/null 2>&1 || { echo >&2 "${yellow}Docker required but it's not installed.  Aborting.${reset}"; exit 1; }
    type virtualbox >/dev/null 2>&1 || { echo >&2 "${yellow}VirtualBox required but it's not installed.  Aborting.${reset}"; exit 1; }
    type kubectl >/dev/null 2>&1 || { echo >&2 "${yellow}kubectl required but it's not installed.  Aborting.${reset}"; exit 1; }
    type minikube >/dev/null 2>&1 || { echo >&2 "${yellow}Minikube required but it's not installed.  Aborting.${reset}"; exit 1; }
}

function continueAfterContainerCreated {
    cmd="kubectl get --no-headers pods --namespace=$1 --selector $2 -o=custom-columns=:.status.phase"
    echo
    echo "${green}Waiting for container to start up...${reset}"
    while [[ $(${cmd}) != Running ]]; do
        printf '.'
        sleep 5;
    done
    echo
}
