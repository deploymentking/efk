#!/usr/bin/env bash

COMPOSE_IGNORE_ORPHANS=true docker-compose -p efk -f docker-compose.yml -f $1/docker-compose.yml up -d --build --no-recreate
