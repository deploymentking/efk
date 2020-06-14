ARG VERSION_FLUENTD=v1.11.0-debian-1.0
FROM fluent/fluentd:${VERSION_FLUENTD}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Fluentd instance"
LABEL Version="2.0.0"

EXPOSE 5140/tcp
EXPOSE 5140/udp
EXPOSE 24223/tcp
EXPOSE 24223/udp
EXPOSE 24224/tcp
EXPOSE 24224/udp
EXPOSE 24231/tcp
EXPOSE 24231/udp

USER root
RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev netcat openssl apt-utils" \
    plugins="fluent-plugin-elasticsearch fluent-plugin-rewrite-tag-filter fluent-plugin-route fluent-plugin-prometheus fluent-plugin-multi-format-parser" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && fluent-gem install $plugins \
    && fluent-gem sources --clear-all \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /fluentd/certs \
    && chmod 777 /fluentd/log/

USER 1000
HEALTHCHECK --interval=5s --timeout=2s --retries=15 CMD nc -z localhost 24224 || exit 1
