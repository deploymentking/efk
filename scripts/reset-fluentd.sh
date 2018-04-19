#!/usr/bin/env bash

DIRECTORY=$(cd `dirname $0` && pwd)
source ${DIRECTORY}/helpers/common.sh

docker-compose -p efk -f docker-compose.yml restart fluentd
clearDockerLog fluentd

while ! nc -z localhost 24224 </dev/null; do sleep 5; done

docker logs -f fluentd
