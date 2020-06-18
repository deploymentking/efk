#!/usr/bin/env bash

docker-compose -f docker-compose.yml down
docker-compose -f docker-compose-clients.yml down --remove-orphans
minikube delete
