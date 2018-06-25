#!/usr/bin/env bash

echo "${green}Creating index pattern MySQL...${reset}"

curl -u kibana:kibana \
    --fail --data "{\"attributes\":{\"title\":\"mysql-*\",\"timeFieldName\":\"@timestamp\"}}" \
    --request "POST" \
    --header "Content-Type: application/json" \
    --header "kbn-xsrf: anything" \
    "http://localhost:5601/api/saved_objects/index-pattern/mysql-*"
