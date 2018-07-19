#!/usr/bin/env bash

directory=$(cd `dirname $0` && pwd)
source ${directory}/../helpers/common.sh

echo
echo "${green}Logs from MySQL instance...${reset}"
kubectl logs --namespace=database $(kubectl get pods -n=database -l run=mysql -o name) -c mysql

echo
echo "${green}Directory listing of /var/log/containers/mysql* in Fluentbit daemonset...${reset}"
kubectl exec -it --namespace=logging \
    $(kubectl get pods -n=logging -l k8s-app=fluent-bit-logging -o go-template --template '{{range .items}}{{.metadata.name}}{{end}}') \
    -- ls -lash /var/log/containers | grep mysql
