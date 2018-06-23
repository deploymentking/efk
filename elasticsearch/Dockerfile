ARG VERSION_EFK=latest
ARG FLAVOUR_EFK="-oss"
FROM docker.elastic.co/elasticsearch/elasticsearch${FLAVOUR_EFK}:${VERSION_EFK}

ARG VERSION_PROJECT
ARG VERSION_ROR

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Elasticsearch instance"
LABEL Version="${VERSION_PROJECT}"

EXPOSE 9200 9300

COPY ./plugins/readonlyrest-${VERSION_ROR}.zip /usr/share/elasticsearch/readonlyrest.zip
COPY ./config/ /usr/share/elasticsearch/config

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b -s file:///usr/share/elasticsearch/readonlyrest.zip \
    && chown -R elasticsearch:root /usr/share/elasticsearch/plugins

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
