#!/usr/bin/env bash

docker logs fluentd

kubectl logs --namespace=database $(kubectl get pods -n=database -l run=mysql -o name) -c mysql

kubectl exec -it --namespace=logging \
    $(kubectl get pods -n=logging -l k8s-app=fluent-bit-logging -o go-template --template '{{range .items}}{{.metadata.name}}{{end}}') \
    -- ls -lash /var/log/containers | grep mysql
