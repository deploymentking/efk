ARG VERSION_ALPINE=alpine3.6
FROM python:${VERSION_ALPINE}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Maintainer="Lee Myring"
LABEL Description="ElasticHQ instance"
LABEL Version="0.1"

EXPOSE 5000

RUN apk add --update musl-dev gcc bash git openssh \
    && rm -rf /var/cache/apk/* \
    && pip install --upgrade pip \
    && git clone https://github.com/ElasticHQ/elasticsearch-HQ /elasticHQ

WORKDIR /elasticHQ

RUN pip install -r requirements.txt

CMD ["python", "application.py", "--port", "5000", "--host", "0.0.0.0"]

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 5000 || exit 1
