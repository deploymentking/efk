#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p fluentd-log-aggregation-my-sql/elasticsearch/config/readonlyrest.yml \
    fluentd-log-aggregation/elasticsearch/config/readonlyrest.yml
