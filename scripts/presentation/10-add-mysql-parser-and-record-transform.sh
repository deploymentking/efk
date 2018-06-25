#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p fluentd-log-aggregation-my-sql/fluentd/config/conf.d/filter_mysql_star_star_parser.conf \
    fluentd-log-aggregation/fluentd/config/conf.d/filter_mysql_star_star_parser.conf

cp -p fluentd-log-aggregation-my-sql/fluentd/config/conf.d/filter_mysql_star_star_record_transform.conf \
    fluentd-log-aggregation/fluentd/config/conf.d/filter_mysql_star_star_record_transform.conf
