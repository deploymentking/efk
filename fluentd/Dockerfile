FROM fluent/fluentd:debian
MAINTAINER DORU Mihai doru.mihai@haufe-lexware.com
LABEL Description="FluentD aggregator docker image" Version="0.1"

RUN ["mkdir", "-p", "/fluentd/certs"]

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && sudo gem install fluent-plugin-elasticsearch --no-rdoc --no-ri \
    && sudo gem install fluent-plugin-rewrite-tag-filter --no-rdoc --no-ri \
    && sudo gem install fluent-plugin-secure-forward --no-rdoc --no-ri \
    && sudo gem sources --clear-all \
    && SUDO_FORCE_REMOVE=yes apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && rm -rf /var/lib/apt/lists/* /usr/lib/ruby/gems/*/cache/*.gem
