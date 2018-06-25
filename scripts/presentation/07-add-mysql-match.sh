#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p fluentd-log-aggregation-my-sql/fluentd/config/conf.d/match_mysql_star_star_out_es.conf \
    fluentd-log-aggregation/fluentd/config/conf.d/match_mysql_star_star_out_es.conf
