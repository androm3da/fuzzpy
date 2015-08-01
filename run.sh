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
export LD_LIBRARY_PATH=${INSTALL_PREFIX}/lib/:${LD_LIBRARY_PATH}
export ASAN_OPTIONS="detect_leaks=0,allocator_may_return_null=1,handle_segv=0,coverage_pcs=1,coverage_dir=${THIS_DIR}/cov/"

mkdir -p ${THIS_DIR}/cov/

DONE=0
finish_up()
{
    DONE=1
}

trap "finish_up $LINENO" INT TERM ERR

test_name=$(basename ${testbin})
token_path="tests/${test_name}/${test_name}.tok"
if [[ -e ${token_path} ]]; then
    TOKEN="-tokens=${token_path}"
else  
    TOKEN=""
fi

${testbin} -runs=${ITERS-1} -jobs=${JOBS} -verbosity=3 -use_traces=1 ${TOKEN} -timeout=10 -max_len=$((16*1024)) -workers=${WORKERS} ${TEST_INPUTS}
