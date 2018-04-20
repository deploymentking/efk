#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/helpers/common.sh

COMPOSE_IGNORE_ORPHANS=true docker-compose -p efk -f docker-compose.yml -f $1/docker-compose.yml up -d --build --no-recreate
