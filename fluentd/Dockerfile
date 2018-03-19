ARG VERSION_FLUENTD
FROM fluent/fluentd:${VERSION_FLUENTD}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Debian Fluentd instance into which other logs should aggregate"
LABEL Version="0.1"

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev netcat openssl" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo gem install fluent-plugin-elasticsearch fluent-plugin-rewrite-tag-filter \
    && sudo gem sources --clear-all \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem \
    && mkdir -p /fluentd/certs

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 24224 || exit 1
