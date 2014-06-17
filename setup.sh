#!/bin/bash

# Variables to configure
VIRTUALENV_NAME=pu
PACKAGE=demosite
PORT=4000

# verbose
set -v
set -o pipefail
IFS=$'\n\t'

# -----------------------------------------------------------------------------

warn () {
    echo "$0:" "$@" >&2
}

die () {
    rc=$1
    shift
    warn "$@"
    exit $rc
}

# Init virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
# Silent bower
mkdir -p $HOME/.config/configstore
echo optOut: true > $HOME/.config/configstore/insight-bower.yml

workon | grep -q ^${VIRTUALENV_NAME}$
if [ "$?" -ne "0" ]; then
    mkvirtualenv ${VIRTUALENV_NAME}
else
    workon ${VIRTUALENV_NAME}
fi


cdvirtualenv

mkdir -p src
rm -rf src/invenio
rm -rf src/demosite
ln -s /opt/invenio src/invenio
ln -s /opt/demosite src/demosite

rm -rf var/invenio.instance-base
mkdir -p var/run
mkdir -p var/tmp
mkdir -p var/tmp-shared


cdvirtualenv src/invenio

# cleaning up old compiled files
find . -iname "*.pyc" -exec rm {} \;

if [ -e requirements-docs.txt ]; then
    pip install -r requirements-docs.txt || die 1 "invenio install failed"
elif [ -e requirements.txt]; then
    pip install -r requirements.txt || die 1 "invenio install failed"
else
    python setup.py develop
fi
if [ -e package.json ]; then
    npm install
fi
if [ -e bower.json ]; then
    bower install
fi
if [ -e Gruntfile.js ]; then
    grunt || die 1 "grunt failed"
fi

pybabel compile -fd invenio/base/translations


cdvirtualenv src/demosite

if [ -e requirements.txt ]; then
    pip install -r requirements.txt --exists-action i || die 1 "demosite install failed"
else
    python setup.py develop || die 1 "demosite install failed"
fi
if [ -e package.json ]; then
    npm install
fi
if [ -e bower.json ]; then
    bower install
fi
if [ -e Gruntfile.js ]; then
    grunt || die 1 "grunt failed"
fi


cdvirtualenv

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backends.console.Mail
inveniomanage config set CFG_BIBSCHED_PROCESS_USER ${USER}
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set CFG_SITE_URL http://0.0.0.0:${PORT}
inveniomanage config set CFG_SITE_SECURE_URL http://0.0.0.0:${PORT}
inveniomanage config set DEBUG True
inveniomanage config set ASSETS_DEBUG True

cdvirtualenv src/invenio

inveniomanage config set CLEANCSS_BIN `find ${PWD}/node_modules -iname cleancss | grep \\.bin | head -1`

inveniomanage config set LESS_BIN `find ${PWD}/node_modules -iname lessc | grep \\.bin |  head -1`
inveniomanage config set LESS_RUN_IN_DEBUG True

inveniomanage config set REQUIREJS_BIN `find ${PWD}/node_modules -iname r.js | grep \\.bin | head -1`
inveniomanage config set REQUIREJS_RUN_IN_DEBUG False
inveniomanage config set REQUIREJS_CONFIG js/build.js

inveniomanage config set UGLIFYJS_BIN `find ${PWD}/node_modules -iname uglifyjs | grep \\.bin | head -1`

inveniomanage config set COLLECT_STORAGE invenio.ext.collect.storage.link


cdvirtualenv

inveniomanage collect

inveniomanage database init --yes-i-know --user=root
inveniomanage database create
inveniomanage demosite create --packages=${PACKAGE}.base

# populate requires the server to be running as well as redis.
inveniomanage runserver &
INVENIO_PID=$!

inveniomanage demosite populate --packages=${PACKAGE}.base

redis-cli flushdb

pkill -TERM -P $INVENIO_PID
