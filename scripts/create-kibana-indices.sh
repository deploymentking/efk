#!/usr/bin/env bash
# From https://github.com/elastic/kibana/issues/3709

set -euo pipefail

# Setting color variables
source ./helpers/common.sh

url="http://kibana:kibana@localhost:5601"
time_field="@timestamp"

# Create index pattern
# curl -f to fail on error

for index_pattern in agent-* \
                     apache-* \
                     bit-* \
                     fluentd-* \
                     gem-* \
                     k8s-* \
                     redis-*
do
    echo
    echo "${green}Creating index pattern $index_pattern...${reset}"
    curl -f -X POST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
      "$url/api/saved_objects/index-pattern/$index_pattern" \
      -d"{\"attributes\":{\"title\":\"$index_pattern\",\"timeFieldName\":\"@timestamp\"}}"
    if [[ ${index_pattern} == "fluentd-*" ]] ; then
        # Make it the default index
        echo
        curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: anything" \
          "$url/api/kibana/settings/defaultIndex" \
          -d"{\"value\":\"$index_pattern\"}"
    fi
done

echo
