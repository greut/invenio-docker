#!/bin/bash

OIFS=$IFS
IFS="#"=; read -a details <<< "$1"
IFS=$OIFS

repository=$details
branch=${details[@]:1}
destination=$(basename $(dirname "${repository}"))/${branch}
depth=50
user=invenio
home=/home/${user}

run () {
    echo "$*"
    su -c "$*" -- ${user}
}

vrun () {
    echo "$*"
    su -c "source ${home}/bin/activate && $*" -- ${user}
}

cd ${home}
# bootstrap the virtualenv
run virtualenv . || exit 1

# clone the project
run git clone --depth=${depth} --branch=${branch} ${repository} ${destination} || exit 1
cd ${destination}
# some stuff for good measures
vrun python --version
vrun pip --version
vrun git log -1

# Silent apt
export DEBIAN_FRONTEND=noninteractive
# Silent bower
export CI=true

run travis before_install || die

supervisord
supervisorctl status

run travis install || exit 1
run travis before_script || exit 1
run travis script
export TRAVIS_TEST_RESULT=$?
if [ $TRAVIS_TEST_RESULT -eq 0 ]; then
    run travis after_success
else
    run travis after_failure
fi
run travis after_script || exit 1

supervisorctl stop all
