#!/usr/bin/env bash

cd ../../

rake restart[elasticsearch,9200]

kubectl delete pod --namespace=database \
    $(kubectl get pods -n=database -l run=mysql -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
