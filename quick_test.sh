#!/bin/bash -ex

set -o pipefail

for test_case in $(find tests/build/ -name 'test*' -executable)
do
    test_name=$(basename ${test_case})
    ITERS=3 ./run.sh ${test_case} tests/${test_name}/inputs/
done
