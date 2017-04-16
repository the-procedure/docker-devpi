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
    devpi-server --start --host 127.0.0.1 --port 3141
    devpi-server --status
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${ROOT_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'
    devpi logoff
    devpi user -c ${PRIVATE_INDEX_USER} password="${PRIVATE_INDEX_PASSWORD}" email=${PRIVATE_INDEX_EMAIL}
    devpi login ${PRIVATE_INDEX_USER} --password="${PRIVATE_INDEX_PASSWORD}"
    devpi index -c pypi bases=root/pypi
    devpi use ${PRIVATE_INDEX_USER}/pypi
    devpi-server --stop
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
