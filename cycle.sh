#!/bin/bash -x

set -o pipefail
set -o errexit

for test_case in tests/test*/test*.py
do
    test_dir=$(dirname ${test_case})

    python2 ./tests/run_test.py ${test_case} ${test_dir}/inputs/
    python3 ./tests/run_test.py ${test_case} ${test_dir}/inputs/
done

for test_case in $(find tests/build/ -name 'test*' -executable)
do
    test_name=$(basename ${test_case})
    SANITY_CHECK=1 ./run.sh ${test_case} tests/${test_name}/inputs/
done
