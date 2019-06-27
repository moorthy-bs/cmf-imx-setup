#!/bin/bash -x

REPO_DIR="~/bin"
REPO_BIN="repo"

if [ ! -d ${REPO_DIR} ]; then
    mkdir -p ${REPO_DIR}
    if [ ! -f ${REPO_DIR}/${REPO_BIN} ]; then
        curl https://storage.googleapis.com/git-repo-downloads/repo > ${REPO_DIR}
        chmod a+x ${REPO_DIR}/${REPO_BIN}
    fi
fi

PATH=${REPO_DIR}:$PATH
