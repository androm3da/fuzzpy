#!/bin/bash -x

set -o pipefail

ITERS_PER_TEST_CASE=${1-1}

for test_case in $(find tests/build/ -name 'test*' -executable)
do
    test_name=$(basename ${test_case})
    ITERS=${ITERS_PER_TEST_CASE} ./run.sh ${test_case} tests/${test_name}/inputs/
done
