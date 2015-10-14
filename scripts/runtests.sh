#!/bin/bash

OIFS=$IFS
IFS="#"=; read -a details <<< "$2"
IFS=$OIFS

repository=$details
branch=${details[@]:1}
destination=$(basename $(dirname "${repository}"))/${branch}
python_version=$1
depth=50
user=invenio
home=/home/${user}
virtual_env=${home}/virtualenv/${python_version}

run () {
    echo "[RUN] $*"
    su -c "source ${virtual_env}/bin/activate && $*" -- ${user}
}

cd ${home}
# travis requires yaml to run
run pip install pyyaml > /dev/null 2>&1

# clone the project
run git clone --depth=${depth} --branch=${branch} ${repository} ${destination} || exit 1
cd ${destination}
# some stuff for good measures
run python --version
run pip --version
run git log -1

# Silent apt
export DEBIAN_FRONTEND=noninteractive
# Silent bower
export CI=true

run travis before_install || exit 2
run travis services || exit 3
run travis install || exit 4
run travis before_script || exit 5
run travis script
export TRAVIS_TEST_RESULT=$?
if [ $TRAVIS_TEST_RESULT -eq 0 ]; then
    run travis after_success
else
    run travis after_failure
fi
run travis after_script

exit $TRAVIS_TEST_RESULT
