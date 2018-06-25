#!/usr/bin/env bash

cd ../../

kubectl create namespace database

kubectl apply -f ./via-k8s/config/mysql.yaml
