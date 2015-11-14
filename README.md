
## fuzzpy
This project is designed to facilitate use cases for fuzzing
python modules (built-in or otherwise), using llvm's `libFuzzer`.

For now, it's only intended for use on linux, x86_64.  

First, build the test cases:

    sudo apt-get build-dep python3
    ./build.sh

Then run one of the test cases like so:

    ./run.sh tests/build/testbz2 tests/testbz2/inputs/


### Trophy case
* http://bugs.python.org/issue25388
