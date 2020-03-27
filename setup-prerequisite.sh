#!/bin/bash -x

REPO_DIR="~/bin"
REPO_BIN="repo"

if [ ! -d ${REPO_DIR} ]; then
    mkdir -p ${REPO_DIR}
fi
if [ ! -f ${REPO_DIR}/${REPO_BIN} ]; then
    curl https://storage.googleapis.com/git-repo-downloads/repo > ${REPO_DIR}/${REPO_BIN}
    chmod a+x ${REPO_DIR}/${REPO_BIN}
fi

export PATH=$PATH:${REPO_DIR}

sudo apt-get update

sudo apt-get install build-essential
# install git > 1.8.3
# install tar > 1.27
# install python3 > 3.4
sudo apt-get install git tar python3
