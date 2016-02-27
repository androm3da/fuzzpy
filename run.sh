#!/bin/bash -ex

set -o pipefail

ulimit -v unlimited

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

# In order to minimize the test corpus, we can
#   rename .../inputs/ to inputs_old/ and
#   libFuzzer will merge the contents forward,
#   preserving only "interesting" cases.
OLD_TESTS=tests/${test_name}/inputs_old/
OUTPUTS=tests/${test_name}/results/
if [[ ${SANITY_CHECK} -ne 0 ]]; then
    MAX_TOTAL="-max_total_time=2"
fi

mkdir -p ${OUTPUTS}
mkdir -p ${OLD_TESTS}

${testbin} -runs=${ITERS-1} \
      -jobs=${JOBS} \
      -verbosity=3 \
      -use_traces=1 \
      -artifact_prefix=${OUTPUTS}/${test_name} \
      -timeout=2000 \
      -max_len=$((16*1024)) \
      -workers=${WORKERS} \
      ${MAX_TOTAL} \
      -merge=1 ${TEST_INPUTS} ${OUTPUTS} ${OLD_TESTS}
