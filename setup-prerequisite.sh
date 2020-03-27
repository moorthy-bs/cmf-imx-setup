#!/bin/bash -x

REPO_DIR="$HOME/bin"
REPO_BIN="repo"

FORCE_DOWNLOAD=0

while [ $# -gt 0 ]; do
    PARAM=`echo $1`
    case $PARAM in
	-f | --force)
            FORCE_DOWNLOAD=1
	    ;;
        *)
	    echo "Error: unknown argument: $PARAM"
	    exit 1
	    ;;
    esac
    shift
done

#### repo tool download
if [ ! -d ${REPO_DIR} ]; then
    mkdir -p ${REPO_DIR}
fi
if [ $FORCE_DOWNLOAD -ne 0 -o ! -f ${REPO_DIR}/${REPO_BIN} ]; then
    curl https://storage.googleapis.com/git-repo-downloads/repo > ${REPO_DIR}/${REPO_BIN}
    chmod a+x ${REPO_DIR}/${REPO_BIN}
fi

export PATH=$PATH:${REPO_DIR}

#### installation of prerequisite packages
sudo apt-get update

sudo apt-get install build-essential
# install git > 1.8.3
# install tar > 1.27
# install python3 > 3.4
sudo apt-get install git tar python3
