ARG VERSION_PROM=v2.3.1
FROM prom/prometheus:${VERSION_PROM}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="Prometheus instance"
LABEL Version="1.0.0"

COPY ./config/prometheus.yml /etc/prometheus/prometheus.yml

#HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
#    CMD curl --silent --fail localhost:9090 || exit 1
