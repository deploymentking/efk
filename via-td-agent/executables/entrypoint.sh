#!/usr/bin/env bash

cat << EOF > /etc/default/td-agent
export FLUENTD_AGGREGATOR_ADDR=${FLUENTD_AGGREGATOR_ADDR}
export FLUENTD_AGGREGATOR_PORT=${FLUENTD_AGGREGATOR_PORT}
export FLUENTD_SOURCE_PROJECT=${FLUENTD_SOURCE_PROJECT}
export FLUENTD_TAIL_TAG=${FLUENTD_TAIL_TAG}
TD_AGENT_OPTIONS="-c /etc/td-agent/${FLUENTD_CONF}"
EOF

chown td-agent:td-agent /etc/default/td-agent
service td-agent restart

nohup java -Dlogger.loopCount=${LOGGER_LOOP_COUNT} \
    -Dlogger.sleep=${LOGGER_THREAD_SLEEP} \
    -cp ./java-logger-${VERSION_JAVA_LOGGER}.jar \
    io.thinkstack.logger.slf4j.${LOGGER_ENTRY_POINT} &

tail -F /var/log/td-agent/td-agent.log
