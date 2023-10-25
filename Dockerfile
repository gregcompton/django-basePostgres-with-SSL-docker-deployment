FROM python:3.10-alpine3.16
LABEL maintainer = "gregcompton.com"

ENV PYTHONUNBUFFERED 1

COPY requirements.txt /requirements.txt
COPY app/ /app

COPY ./scripts /scripts


WORKDIR /app

EXPOSE 8000


#RUN apk add --upgrade --no-cache build-base linux-headers && \
#    pip install --upgrade pip && \
#    pip install -r /requirements.txt



RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps build-base postgresql-dev musl-dev linux-headers && \
    /py/bin/pip install -r /requirements.txt && \
    apk del .tmp-deps

RUN adduser --disabled-password --no-create-home django && \
    adduser --disabled-password --no-create-home app

RUN  mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    chown -R app:app /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

ENV PATH="/scripts:/py/bin:$PATH"

USER app

#CMD ["uwsgi", "--socket", ":9000", "--workers", "4", "--master", "--enable-threads", "--module", "app.wsgi"]
CMD ["run.sh"]