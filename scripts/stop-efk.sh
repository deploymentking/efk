#!/usr/bin/env bash

docker-compose -p efk -f docker-compose.yml down --remove-orphans
minikube delete
