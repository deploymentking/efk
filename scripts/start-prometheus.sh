#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh

COMPOSE_IGNORE_ORPHANS=true docker-compose -p efk -f docker-compose.yml -f prometheus/docker-compose.yml up -d --build --no-recreate

checkURL "curl -X GET" "http://localhost:9090/status"
open "http://localhost:9090/status"
