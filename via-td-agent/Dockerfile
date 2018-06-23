ARG VERSION_UBUNTU=18.04
FROM ubuntu:${VERSION_UBUNTU}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Ubuntu instance to test source of log data"
LABEL Version="0.1"

EXPOSE 9292

RUN buildDeps="sudo make gcc g++ libc-dev libssl-dev libxml2-dev libxslt1-dev ruby-dev curl gnupg software-properties-common net-tools" \
    && apt-get update \
    && apt-get install -yq --no-install-recommends $buildDeps \
    && curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add - \
    && echo "deb http://packages.treasuredata.com/3/ubuntu/xenial/ xenial contrib" > /etc/apt/sources.list.d/treasure-data.list \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends openjdk-8-jdk openjdk-8-jre td-agent \
    && update-alternatives --config java \
    && update-alternatives --config javac \
    && echo 'gem: --no-document' > /etc/gemrc \
    && gem install fluentd-ui --no-ri --no-rdoc \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem \
    && mkdir -p /etc/td-agent/certs

COPY ./bin /bin

RUN chmod 755 /bin/entrypoint.sh && chown -R td-agent:td-agent /etc/td-agent

ENTRYPOINT ["/bin/entrypoint.sh"]
