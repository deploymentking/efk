#!/usr/bin/env bash

export FLUENTD_AGGREGATOR_HOST=${FLUENTD_AGGREGATOR_HOST}
export FLUENTD_AGGREGATOR_PORT=${FLUENTD_AGGREGATOR_PORT}
export FLUENTD_SOURCE_PROJECT=${FLUENTD_SOURCE_PROJECT}
export FLUENTD_TAIL_TAG=${FLUENTD_TAIL_TAG}
export LOGGER_FILE_PATH=${LOGGER_FILE_PATH}

nohup java -Dlogger.filePath=${LOGGER_FILE_PATH} \
           -Dlogger.loopCount=${LOGGER_LOOP_COUNT} \
           -Dlogger.sleep=${LOGGER_THREAD_SLEEP} \
           -cp /bin/java-logger-${LOGGER_VERSION}.jar \
           io.thinkstack.logger.slf4j.${LOGGER_ENTRY_POINT} &

fluentd
