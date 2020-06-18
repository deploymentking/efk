ARG VERSION_EFK=7.7.1
FROM docker.elastic.co/kibana/kibana:${VERSION_EFK}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Kibana instance"
LABEL Version="2.0.0"

USER root
RUN buildDeps="sudo nc" \
    && yum -y update \
    && yum -y install ${buildDeps}

USER 1000
HEALTHCHECK --interval=5s --timeout=2s --retries=15 CMD nc -z kibana 5601 || exit 1
