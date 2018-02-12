FROM fluentd:debian
LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Ubuntu instance to test source of log data" Version="0.1"

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y $buildDeps \
    && apt-get install td-agent \
    && mkdir -p /logsource/certs /logsource/log

#COPY ./certs/ca_cert.pem /logsource/certs
#COPY ./config/td-agent-shipper-tls.conf /logsource/etc
#COPY ./config/install-td-agent.sh /

RUN sudo td-agent-gem install fluent-plugin-elasticsearch

RUN tail /var/log/td-agent/td-agent.log

