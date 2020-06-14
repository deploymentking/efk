#!/usr/bin/env bash

set -x

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh

checkPreRequisites

source ../.envrc

docker-compose -f docker-compose.yml up -d --build

while ! nc -z localhost 9200 </dev/null; do sleep 5; done
while ! nc -z localhost 5601 </dev/null; do sleep 5; done
while ! nc -z localhost 24224 </dev/null; do sleep 5; done

# Check entire elasticsearch cluster
checkURL "${elasticsearchCurlPrefix}" "-X GET http://localhost:9200/_cluster/health"
checkURL "${elasticsearchCurlPrefix}" "-X GET http://localhost:9201/_cluster/health"
checkURL "${elasticsearchCurlPrefix}" "-X GET http://localhost:9202/_cluster/health"

checkURL "${kibanaCurlPrefix}" "${kibanaUrl}/app/kibana#"
createKibanaIndices
open "${kibanaUrl}/app/kibana#/discover?_g=()"
