#
FROM python:3.5

ENV PYTHONUNBUFFERED 1

ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL="https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST="127.0.0.1"
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup --system --gid 1000 devpi \
    && adduser --system --uid 1000 --disabled-password --home /data --shell /sbin/nologin --ingroup devpi devpi

# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install pip==$PYTHON_PIP_VERSION
ENV PATH $VIRTUAL_ENV/bin:$PATH

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

EXPOSE 3141
VOLUME /data

COPY ./compose/devpi/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 777 /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
