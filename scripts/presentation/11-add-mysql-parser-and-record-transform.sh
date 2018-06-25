#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p efk-my-sql/fluentd/config/conf.d/filter_mysql_star_star_parser.conf \
    efk/fluentd/config/conf.d/filter_mysql_star_star_parser.conf

cat efk/fluentd/config/conf.d/filter_mysql_star_star_parser.conf

cp -p efk-my-sql/fluentd/config/conf.d/filter_mysql_star_star_record_transform.conf \
    efk/fluentd/config/conf.d/filter_mysql_star_star_record_transform.conf

cat efk/fluentd/config/conf.d/filter_mysql_star_star_record_transform.conf
