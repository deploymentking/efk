ARG VERSION_ELASTICHQ=latest
FROM elastichq/elasticsearch-hq:${VERSION_ELASTICHQ}

ARG VERSION_EFK

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="ElasticHQ instance"
LABEL Version="${VERSION_EFK}"

EXPOSE 5000

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 5000 || exit 1
