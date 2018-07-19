#!/usr/bin/env bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

kibanaCurlPrefix="curl -u kibana:kibana"
kibanaUrl="http://localhost:5601"

elasticsearchCurlPrefix="curl -u elastichq:elastichq"
elasticsearchUrl="http://localhost:9200"

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

    # Setup the default template
    echo
    echo "${green}Creating default index template default_index_template_wildcard_box_type_hot...${reset}"
    curl -X PUT "${elasticsearchUrl}/_template/default_index_template_wildcard_box_type_hot" \
        -H 'Content-Type: application/json' \
        -d'{"index_patterns":["*"],"settings":{"number_of_shards":"1","number_of_replicas":"0","index":{"routing":{"allocation":{"require":{"box_type":"hot"}}}}}}'
    echo

    # Setup the index patterns
    for index_pattern in agent-* \
                         apache-* \
                         bit-* \
                         fluent-* \
                         gem-* \
                         k8s-* \
                         kitchen-* \
                         redis-*
    do
        url="$kibanaUrl/api/saved_objects/index-pattern/$index_pattern"

        response=$(${kibanaCurlPrefix} --write-out %{http_code} --silent --output /dev/null ${url} -H 'kbn-xsrf: true')

        if [[ "${response}" == "200" ]] ; then
            echo "${yellow}Index pattern $index_pattern already exists...${reset}"
        else
            echo "${green}Creating index pattern $index_pattern...${reset}"

            data="{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"@timestamp\"}}"
            ${kibanaCurlPrefix} --fail --data "$data" --request "POST" --header "Content-Type: application/json" --header "kbn-xsrf: anything" ${url}

            if [[ ${index_pattern} == "fluent-*" ]] ; then
                # Make fluentd the default index
                url="$kibanaUrl/api/kibana/settings/defaultIndex"
                data="{\"value\":\"$index_pattern\"}"
                echo
                ${kibanaCurlPrefix} --data "$data" --request "POST" --header "Content-Type: application/json" --header "kbn-xsrf: anything" ${url}
            fi
        fi
    done
    echo
}
