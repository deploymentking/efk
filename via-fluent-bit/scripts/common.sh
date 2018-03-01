#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

function continueAfterContainerCreated {
    echo "${green}Waiting for container to start up...${reset}"
    while [[ $($1) != Running ]]; do
        printf '.'
        sleep 5;
    done
    echo
}
