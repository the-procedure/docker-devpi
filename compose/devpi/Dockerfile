#
FROM python:3.5-alpine

ENV PYTHONUNBUFFERED 1

ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup -S -g 1000 devpi \
    && adduser -D -S -u 1000 -h /data -s /sbin/nologin -G devpi devpi

# entrypoint is written in bash
RUN apk add --no-cache bash
 
# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install pip==$PYTHON_PIP_VERSION
ENV PATH $VIRTUAL_ENV/bin:$PATH

COPY ./requirements /requirements
RUN pip install -r /requirements/production.txt \
    && oroupadd -r django \
    && useradd -r -g django django

EXPOSE 3141
VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
