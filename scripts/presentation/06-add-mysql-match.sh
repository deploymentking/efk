#!/usr/bin/env bash

cd ~/source/deploymentking/

cat efk-my-sql/fluentd/config/conf.d/match_mysql_star_star_out_es.conf

cp -p efk-my-sql/fluentd/config/conf.d/match_mysql_star_star_out_es.conf \
    efk/fluentd/config/conf.d/match_mysql_star_star_out_es.conf
