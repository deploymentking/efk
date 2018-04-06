#!/usr/bin/env bash

kubectl delete ds fluent-bit --namespace=logging
kubectl delete configmap fluent-bit-config --namespace=logging
sleep 5
kubectl apply -f ./config/fluent-bit-configmap.yaml --namespace=logging
sleep 5
kubectl apply -f ./config/fluent-bit-ds-minikube.yaml --namespace=logging
