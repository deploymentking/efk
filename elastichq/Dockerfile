ARG VERSION_PYTHON
FROM python:${VERSION_PYTHON}

LABEL Author="Lee Myring <mail@thinkstack.io>"
LABEL Description="ElasticHQ instance"
LABEL Version="0.1"

RUN apk add --update bash git openssh \
    && rm -rf /var/cache/apk/* \
    && git clone https://github.com/ElasticHQ/elasticsearch-HQ /elasticHQ

WORKDIR /elasticHQ

RUN pip install -r requirements.txt

CMD ["python", "application.py", "--port", "5000", "--host", "0.0.0.0"]

HEALTHCHECK --interval=5s --timeout=2s --retries=15 \
    CMD nc -z localhost 5000 || exit 1
