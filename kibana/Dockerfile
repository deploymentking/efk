ARG VERSION_EFK=latest
ARG FLAVOUR_EFK="-oss"
FROM docker.elastic.co/kibana/kibana${FLAVOUR_EFK}:${VERSION_EFK}

ARG VERSION_EFK

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Kibana instance"
LABEL Version="${VERSION_EFK}"

EXPOSE 5601
