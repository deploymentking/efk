#!/usr/bin/env bash

cd ~/source/deploymentking/

cp -p efk-my-sql/fluentd/config/conf.d/match_kube_star_star_rewrite_tag.conf \
    efk/fluentd/config/conf.d/match_kube_star_star_rewrite_tag.conf

cat efk/fluentd/config/conf.d/match_kube_star_star_rewrite_tag.conf
