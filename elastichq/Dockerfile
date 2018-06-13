ARG VERSION_ELASTICHQ=release-v3.4.0
FROM elastichq/elasticsearch-hq:${VERSION_ELASTICHQ}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Maintainer="Lee Myring"
LABEL Description="ElasticHQ instance"
LABEL Version="0.1"

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 5000 || exit 1
