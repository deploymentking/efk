#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh
source ${directory}/../.envrc

checkPreRequisites

docker-compose -f docker-compose-clients.yml up -d --build

while ! nc -z localhost 5601 </dev/null; do sleep 5; done

checkURL "${kibanaCurlPrefix}" "${kibanaUrl}/app/kibana#"
createKibanaIndices
open "${kibanaUrl}/app/kibana#/discover?_g=()"
