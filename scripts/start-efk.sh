#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
source ${DIRECTORY}/helpers/common.sh

docker-compose -p efk -f docker-compose.yml down
docker-compose -p efk -f docker-compose.yml up -d --build

while ! nc -z localhost 9200 </dev/null; do sleep 5; done
while ! nc -z localhost 5601 </dev/null; do sleep 5; done
while ! nc -z localhost 24224 </dev/null; do sleep 5; done

checkURL "${kibanaCurlPrefix}" "${kibanaUrl}/app/kibana#"
createKibanaIndices
open "${kibanaUrl}/app/kibana#"

docker logs -f fluentd
