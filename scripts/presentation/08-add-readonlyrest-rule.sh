#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p efk-my-sql/elasticsearch/config/readonlyrest.yml \
    efk/elasticsearch/config/readonlyrest.yml

cat efk/elasticsearch/config/readonlyrest.yml
