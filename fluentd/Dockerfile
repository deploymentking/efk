ARG VERSION_FLUENTD=v1.1.3-debian-onbuild
FROM fluent/fluentd:${VERSION_FLUENTD}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Fluentd instance"
LABEL Version="1.0.0"

EXPOSE 5140/tcp
EXPOSE 5140/udp
EXPOSE 24223/tcp
EXPOSE 24223/udp
EXPOSE 24224/tcp
EXPOSE 24224/udp
EXPOSE 24231/tcp
EXPOSE 24231/udp

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev netcat openssl" \
    plugins="fluent-plugin-elasticsearch fluent-plugin-rewrite-tag-filter fluent-plugin-route fluent-plugin-prometheus fluent-plugin-multi-format-parser" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo fluent-gem install $plugins \
    && sudo fluent-gem sources --clear-all \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem \
    && mkdir -p /fluentd/certs

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 24224 || exit 1
