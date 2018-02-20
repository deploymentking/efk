ARG VERSION_ELK
ARG FLAVOUR_ELK
FROM docker.elastic.co/elasticsearch/elasticsearch${FLAVOUR_ELK}:${VERSION_ELK}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Elasticsearch instance"
LABEL Version="0.1"

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
