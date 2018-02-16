ARG VERSION_FLUENTD
FROM fluent/fluentd:${VERSION_FLUENTD}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Alpine FluentD instance into which other logs should aggregate"
LABEL Version="0.1"

RUN apk add --update --virtual .build-deps sudo build-base ruby-dev \
    && sudo gem install fluent-plugin-elasticsearch fluent-plugin-rewrite-tag-filter fluent-plugin-secure-forward\
    && sudo gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /home/fluent/.gem/ruby/2.3.0/cache/*.gem \
    && mkdir -p /fluentd/certs

COPY ./certs /fluentd/certs
