#!/usr/bin/env bash

cat << EOF > /etc/default/td-agent
export FLUENTD_AGGREGATOR_HOST=${FLUENTD_AGGREGATOR_HOST}
export FLUENTD_AGGREGATOR_PORT=${FLUENTD_AGGREGATOR_PORT}
export FLUENTD_SOURCE_PROJECT=${FLUENTD_SOURCE_PROJECT}
export FLUENTD_TAIL_TAG=${FLUENTD_TAIL_TAG}
export LOGGER_FILE_PATH=${LOGGER_FILE_PATH}
export FLUENTD_HOSTNAME=${FLUENTD_HOSTNAME}
export FLUENTD_SHARED_KEY=${FLUENTD_SHARED_KEY}
TD_AGENT_OPTIONS="-c /etc/td-agent/${FLUENTD_CONF}"
EOF

chown td-agent:td-agent /etc/default/td-agent
service td-agent restart

nohup java -Dlogger.filePath=${LOGGER_FILE_PATH} \
           -Dlogger.loopCount=${LOGGER_LOOP_COUNT} \
           -Dlogger.sleep=${LOGGER_THREAD_SLEEP} \
           -cp /bin/java-logger-${LOGGER_VERSION}.jar \
           io.thinkstack.logger.slf4j.${LOGGER_ENTRY_POINT} &

if [ "$FLUENTD_UI_ENABLED" = true ] ; then
    # Run fluentd-ui to bring up the rails app...or...
    fluentd-ui start
else
    # ...use this to keep the container running
    tail -F -n 100 /var/log/td-agent/td-agent.log
fi
