ARG VERSION_UBUNTU
FROM ubuntu:${VERSION_UBUNTU}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Ubuntu instance to test source of log data"
LABEL Version="0.1"

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev curl gnupg" \
    && apt-get update \
    && apt-get install -yq --no-install-recommends $buildDeps \
    && curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add - \
    && echo "deb http://packages.treasuredata.com/3/ubuntu/xenial/ xenial contrib" > /etc/apt/sources.list.d/treasure-data.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends td-agent \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/td-agent/certs \
    && /etc/init.d/td-agent restart

COPY ./certs /etc/td-agent/certs
COPY ./config/td-agent-default-install.conf /etc/td-agent/td-agent.conf
