ARG VERSION_FLUENTD=latest
FROM fluent/fluentd:${VERSION_FLUENTD}

ARG VERSION_EFK

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Debian Fluentd instance into which other logs should aggregate"
LABEL Version="${VERSION_EFK}"

EXPOSE 24223 24224

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev netcat openssl" \
    plugins="fluent-plugin-elasticsearch fluent-plugin-rewrite-tag-filter fluent-plugin-route fluent-plugin-multi-format-parser" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo fluent-gem install $plugins \
    && sudo fluent-gem sources --clear-all \
    && rm -rf /var/lib/apt/lists/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem \
    && mkdir -p /fluentd/certs

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 24224 || exit 1
