#!/usr/bin/env bash

cd ../../

kubectl delete pod --namespace=database \
    $(kubectl get pods -n=database -l run=mysql -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')

rake restart[fluentd,24224]
