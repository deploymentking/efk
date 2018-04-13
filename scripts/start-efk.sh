#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)

source ${DIRECTORY}/helpers/common.sh

docker-compose -p efk -f docker-compose.yml down
clearDockerLog fluentd
docker-compose -p efk -f docker-compose.yml up -d --build

while ! nc -z localhost 9200 </dev/null; do sleep 10; done
while ! nc -z localhost 5601 </dev/null; do sleep 10; done
while ! nc -z localhost 24224 </dev/null; do sleep 10; done

echo "${green}Going to sleep until $(date -v+10S "+%T")${reset}"
sleep 10

createKibanaIndices

open "http://localhost:5601/app/kibana#/discover?_g=()"

docker logs -f fluentd
