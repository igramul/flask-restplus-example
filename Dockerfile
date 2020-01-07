FROM python:3.6-alpine AS build

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

RUN python3 -m venv venv
RUN venv/bin/pip install --upgrade pip setuptools --proxy "$HTTP_PROXY"
COPY requirements.txt requirements.txt
RUN venv/bin/pip install -r requirements.txt --proxy "$HTTP_PROXY"


FROM python:3.6-alpine

WORKDIR /home/todo

RUN adduser -D todo

COPY todo.py docker-entrypoint.sh ./

RUN chmod a+x docker-entrypoint.sh

COPY --from=build venv /venv

ENV FLASK_APP todo.py

USER todo

EXPOSE 5000
ENTRYPOINT ["./docker-entrypoint.sh"]
