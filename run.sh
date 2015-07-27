#!/bin/bash -ex

set -o pipefail

testbin=${1?"err specify test"}
TEST_INPUTS=${2?"err specify test"}

THIS_FILE=${BASH_SOURCE}
THIS_DIR=$(dirname ${THIS_FILE})
source ${THIS_DIR}/config.sh

[[ ${PROCS} -gt 3 ]] && WORKERS=$((${PROCS} - 1)) || WORKERS=2
JOBS=$((${WORKERS} / 2 ))
export PYTHONPATH=${INSTALL_PREFIX}/lib/python3.6
export ASAN_OPTIONS="detect_leaks=0,allocator_may_return_null=1,handle_segv=0"

DONE=0
finish_up()
{
    DONE=1
}

trap "finish_up $LINENO" INT TERM ERR

while [[ ${DONE} -ne 1 ]]
do
    ${testbin} -runs=1000 -jobs=${JOBS} -use_traces=1 -timeout=10 -max_len=256 -workers=${WORKERS} ${TEST_INPUTS}
done
