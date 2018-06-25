#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p fluentd-log-aggregation-my-sql/fluentd/config/conf.d/match_kube_star_star_rewrite_tag.conf \
    fluentd-log-aggregation/fluentd/config/conf.d/match_kube_star_star_rewrite_tag.conf
