FROM python:3.9-slim-bookworm

WORKDIR /app

RUN pip3 install --no-cache-dir flask pyuwsgi && \
    /usr/sbin/groupadd -r uwsgi && /usr/sbin/useradd --no-log-init -r -g uwsgi uwsgi

COPY app /app

RUN chown -R uwsgi:uwsgi /app

WORKDIR ${APP_DIR}

USER uwsgi

CMD ["uwsgi", "--http-socket", ":8888", "--master", "-w", "hello:app"]

EXPOSE 8888
