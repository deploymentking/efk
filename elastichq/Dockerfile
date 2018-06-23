ARG VERSION_ELASTICHQ=release-v3.4.0
FROM elastichq/elasticsearch-hq:${VERSION_ELASTICHQ}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="ElasticHQ instance"
LABEL Version="1.0.0"

EXPOSE 5000

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 5000 || exit 1
