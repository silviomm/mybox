#!/bin/bash

CURRENT_DIR=$(pwd)
SCRIPT_BASE=$(dirname $0)

cd ${SCRIPT_BASE}

USE_CURRENT_DIR=true
if [[ -n "$USE_CURRENT_DIR" ]]; then
    cd $CURRENT_DIR
    OPTIONS="${OPTIONS} -v ${CURRENT_DIR}:/dir -w /dir"
    cd ${SCRIPT_BASE}
fi;

docker compose -f "${SCRIPT_BASE}/src/docker-compose.yml" run ${OPTIONS} --rm --build mybox