#!/bin/bash

function defaults {
    : ${DEVPI_SERVERDIR="/data/server"}
    : ${DEVPI_CLIENTDIR="/data/client"}

    echo "DEVPI_SERVERDIR is ${DEVPI_SERVERDIR}"
    echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

    export DEVPI_SERVERDIR DEVPI_CLIENTDIR
}

function initialise_devpi {
    echo "[RUN]: Initialise devpi-server"
    devpi-server --init
    echo "[RUN]: Initialise devpi-server 1"
    devpi-server --start --host 127.0.0.1 --port 3141
    echo "[RUN]: Initialise devpi-server 2"
    devpi-server --status
    echo "[RUN]: Initialise devpi-server 3"
    devpi use http://localhost:3141
    echo "[RUN]: Initialise devpi-server 4"
    devpi login root --password=''
    echo "[RUN]: Initialise devpi-server 5"
    devpi user -m root password="${ROOT_PASSWORD}"
    echo "[RUN]: Initialise devpi-server 6"
    devpi index -y -c public pypi_whitelist='*'
    echo "[RUN]: Initialise devpi-server 7"
    devpi logoff
    echo "[RUN]: Initialise devpi-server 8"
    devpi user -c ${PRIVATE_INDEX_USER} password="${PRIVATE_INDEX_PASSWORD}" email=${PRIVATE_INDEX_EMAIL}
    echo "[RUN]: Initialise devpi-server 9"
    devpi login ${PRIVATE_INDEX_USER} --password="${PRIVATE_INDEX_PASSWORD}"
    echo "[RUN]: Initialise devpi-server 10"
    devpi index -c pypi bases=root/pypi
    echo "[RUN]: Initialise devpi-server 11"
    devpi use ${PRIVATE_INDEX_USER}/pypi
    echo "[RUN]: Initialise devpi-server 12"
    devpi-server --stop
    echo "[RUN]: Initialise devpi-server 13"
    devpi-server --recreate-search-index
    echo "[RUN]: Initialise devpi-server 14"
    devpi-server --status
}

defaults

if [ "$1" = 'devpi' ]; then
    if [ ! -f  $DEVPI_SERVERDIR/.serverversion ]; then
        initialise_devpi
    fi

    echo "[RUN]: Launching devpi-server"
    exec devpi-server --restrict-modify ${PRIVATE_INDEX_USER} --host 0.0.0.0 --port 3141 --theme semantic-ui
fi

echo "[RUN]: Builtin command not provided [devpi]"
echo "[RUN]: $@"

exec "$@"
