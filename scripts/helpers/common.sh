#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

kibanaCurlPrefix="curl -u kibana:kibana"
kibanaUrl="http://localhost:5601"

function clearDockerLog {
    dockerLogFile=$(docker inspect $1 | grep -G '\"LogPath\": \"*\"' | sed -e 's/.*\"LogPath\": \"//g' | sed -e 's/\",//g');
    rmCommand="rm $dockerLogFile";
    screen -d -m -S dockerlogdelete ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty;
    screen -S dockerlogdelete -p 0 -X stuff "$rmCommand";
    screen -S dockerlogdelete -p 0 -X stuff '\n';
    screen -S dockerlogdelete -X quit
}

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

# From https://github.com/elastic/kibana/issues/3709
function createKibanaIndices {
    set -euo pipefail

    for index_pattern in agent-* \
                         apache-* \
                         bit-* \
                         fluent-* \
                         gem-* \
                         k8s-* \
                         redis-*
    do
        echo
        echo "${green}Creating index pattern $index_pattern...${reset}"
        ${kibanaCurlPrefix} -f -X POST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
          "${kibanaUrl}/api/saved_objects/index-pattern/$index_pattern" \
          -d"{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"@timestamp\"}}"
        if [[ ${index_pattern} == "fluentd-*" ]] ; then
            # Make fluentd the default index
            echo
            ${kibanaCurlPrefix} -X POST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
              "${kibanaUrl}/api/kibana/settings/defaultIndex" \
              -d"{\"value\":\"$index_pattern\"}"
        fi
    done
    echo
}

function checkURL {
    echo "${green}Waiting for URL $2${reset}"
    until $(eval '$1 --output /dev/null --silent --head --fail $2'); do
        printf '.'
        sleep 5
    done
    echo
}
