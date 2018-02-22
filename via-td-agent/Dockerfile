ARG VERSION_UBUNTU
FROM ubuntu:${VERSION_UBUNTU}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Ubuntu instance to test source of log data"
LABEL Version="0.1"

RUN buildDeps="sudo make gcc g++ libc-dev ruby-dev curl gnupg software-properties-common" \
    && apt-get update \
    && apt-get install -yq --no-install-recommends $buildDeps \
    && curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add - \
    && echo "deb http://packages.treasuredata.com/3/ubuntu/xenial/ xenial contrib" > /etc/apt/sources.list.d/treasure-data.list \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends openjdk-8-jdk openjdk-8-jre td-agent \
    && update-alternatives --config java \
    && update-alternatives --config javac \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/td-agent/certs

COPY ./executables /bin

RUN chmod 755 /bin/entrypoint.sh && chown -R td-agent:td-agent /etc/td-agent

ENTRYPOINT ["/bin/entrypoint.sh"]
