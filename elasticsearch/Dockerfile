ARG VERSION_EFK=7.7.1
FROM docker.elastic.co/elasticsearch/elasticsearch:${VERSION_EFK}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Elasticsearch instance"
LABEL Version="2.0.0"

EXPOSE 9200 9300
HEALTHCHECK --interval=5s --timeout=2s --retries=15 CMD nc -z elasticsearch 9200 || exit 1
