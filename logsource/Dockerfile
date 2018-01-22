FROM ubuntu
MAINTAINER Lee Myring mail@thinkstack.io
LABEL Description="Ubuntu instance to test source of log data" Version="0.1"

RUN ["mkdir", "-p", "/fluentd/certs"]
RUN ["mkdir", "-p", "/fluentd/log"]

ADD ./certs/ca_cert.pem /fluentd/certs
ADD ./config/td-agent-shipper.conf /fluentd/etc

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
    && apt update \
    && apt upgrade
    && apt install -y $buildDeps \
