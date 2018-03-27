ARG VERSION_ELK
ARG FLAVOUR_ELK
FROM docker.elastic.co/elasticsearch/elasticsearch${FLAVOUR_ELK}:${VERSION_ELK}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Elasticsearch instance"
LABEL Version="0.1"

COPY ./plugins/readonlyrest-1.16.17_es6.2.2.zip /usr/share/elasticsearch

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b -s file:///usr/share/elasticsearch/readonlyrest-1.16.17_es6.2.2.zip \
    && chown -R elasticsearch:root /usr/share/elasticsearch/plugins

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
