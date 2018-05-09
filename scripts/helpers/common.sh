#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

kibanaCurlPrefix="curl -u kibana:kibana"
kibanaUrl="http://localhost:5601"

# Check if all the essential tools are installed
function checkPreRequisites {
    echo
    echo "${green}Checking pre-requisites...${reset}"
    type ruby >/dev/null 2>&1 || { echo >&2 "${yellow}Ruby required but it's not installed.  Aborting.${reset}"; exit 1; }
    type docker >/dev/null 2>&1 || { echo >&2 "${yellow}Docker required but it's not installed.  Aborting.${reset}"; exit 1; }
    type virtualbox >/dev/null 2>&1 || { echo >&2 "${yellow}VirtualBox required but it's not installed.  Aborting.${reset}"; exit 1; }
    type kubectl >/dev/null 2>&1 || { echo >&2 "${yellow}kubectl required but it's not installed.  Aborting.${reset}"; exit 1; }
    type minikube >/dev/null 2>&1 || { echo >&2 "${yellow}Minikube required but it's not installed.  Aborting.${reset}"; exit 1; }
}

# Wait for a container to be running before continuing processing
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

# Restart a running container, wait for it to respond on open port and then tail logs since the restart
function restartContainer {
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    directory=$(cd `dirname $0` && pwd)
    container=$1
    port=$2

    docker-compose -p efk -f docker-compose.yml restart ${container}

    if [[ ! -z ${port} ]]; then
        while ! nc -z localhost ${port} </dev/null; do sleep 5; done
    fi

    docker logs --follow --since ${timestamp} ${container}
}

# Given the start of the curl command and the URL, wait for the curl to return successfully
function checkURL {
    echo "${green}Waiting for URL $2${reset}"
    until $(eval '$1 --output /dev/null --silent --head --fail $2'); do
        printf '.'
        sleep 5
    done
    echo
}

# From https://github.com/elastic/kibana/issues/3709
function createKibanaIndices {
    set -euo pipefail

    content_type="Content-Type: application/json"
    kbn_xsrf_header="kbn-xsrf: anything"
    action=POST

    for index_pattern in agent-* \
                         apache-* \
                         bit-* \
                         fluent-* \
                         gem-* \
                         k8s-* \
                         kitchen-* \
                         redis-*
    do
        echo
        echo "${green}Creating index pattern $index_pattern...${reset}"

        url="$kibanaUrl/api/saved_objects/index-pattern/$index_pattern"
        data="{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"@timestamp\"}}"

        ${kibanaCurlPrefix} --fail --data "$data" --request "$action" --header "$content_type" --header "$kbn_xsrf_header" ${url}

        if [[ ${index_pattern} == "fluent-*" ]] ; then
            # Make fluentd the default index
            url="$kibanaUrl/api/kibana/settings/defaultIndex"
            data="{\"value\":\"$index_pattern\"}"
            echo
            ${kibanaCurlPrefix} --data "$data" --request "$action" --header "$content_type" --header "$kbn_xsrf_header" ${url}
        fi
    done
    echo
}