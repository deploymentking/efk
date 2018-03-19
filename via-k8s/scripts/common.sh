#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function continueAfterContainerCreated {
    cmd="kubectl get --no-headers pods --namespace=$1 --selector $2 -o=custom-columns=:.status.phase"
    echo "${green}Waiting for container to start up...${reset}"
    while [[ $(${cmd}) != Running ]]; do
        printf '.'
        sleep 5;
    done
    echo
}
