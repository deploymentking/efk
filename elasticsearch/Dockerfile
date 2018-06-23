ARG VERSION_EFK=6.2.2
ARG FLAVOUR_EFK="-oss"
FROM docker.elastic.co/elasticsearch/elasticsearch${FLAVOUR_EFK}:${VERSION_EFK}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Elasticsearch instance"
LABEL Version="0.1"

EXPOSE 9200

COPY ./plugins/readonlyrest-1.16.17_es6.2.2.zip /usr/share/elasticsearch
COPY ./config/ /usr/share/elasticsearch/config

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b -s file:///usr/share/elasticsearch/readonlyrest-1.16.17_es6.2.2.zip \
    && chown -R elasticsearch:root /usr/share/elasticsearch/plugins

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
