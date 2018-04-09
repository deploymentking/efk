ARG VERSION_CENTOS=7
FROM centos:${VERSION_CENTOS}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Centos instance to test source of log data installed and configured manually"
LABEL Version="0.1"

COPY repos.d/td-agent-bit.repo /etc/yum.repos.d/

RUN buildDeps="td-agent-bit java-1.8.0-openjdk" \
    && yum -y update \
    && yum -y install $buildDeps \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && mkdir /var/log/td-agent-bit/ \
    && touch /var/log/td-agent-bit/td-agent-bit.log

COPY ./bin /bin
RUN chmod 755 /bin/entrypoint.sh
ENTRYPOINT ["/bin/entrypoint.sh"]
