
## fuzzpy
This project is designed to facilitate use cases for fuzzing
CPython modules (built-in or otherwise), using llvm's
[`libFuzzer`](http://llvm.org/docs/LibFuzzer.html).  This library offers
coverage-guided fuzzing which provides feedback to optimize test iterations
for regions of code that our testing hasn't hit yet, or hasn't covered well
yet.

For now, it's only tested on linux/`x86_64` and ARM7 (`armv7l-gnueabihf`),
focusing on CPython.

### Building

First, make sure you've cloned this repository with its subrepositories (e.g.
  `git clone --recursive https://bitbucket.org/ebadf/fuzzpy`).  
Then build the dependencies and test cases using the script provided.  

    sudo apt-get build-dep python3
    ./build.sh

This will take quite some time because we're actually going to build a C/C++
compiler suite prior to building `libpython` and our test cases.  If you've
got a recent (3.7+) local `clang`/`llvm` install, you can dive in to building
the test cases directly.  This guide and the build infrastructure in this
repo assume you're using the integrated `llvm` tree.

### Running
You may run one of the existing test cases like so:

    ./run.sh tests/build/testbz2 tests/testbz2/inputs/

It's unfortunately extremely slow relative to other typical `libFuzzer` cases.
But, hey, CPython is not like most of those other cases.  :)

Hopefully you should continue to see entries like these below:

    NEW0: 32244 L 2
    NEW0: 32244 L 2

These indicate that the fuzzer is making progress into previously
untested code paths.

Output will go into two places:

    ./tests/<testcase>/inputs/ # distinct test cases
    ./cov/ # coverage record

If you encounter a crashing input, it should get recorded as
`crash-extremelylonghashofinputdata`.  That hash should avoid the risk of
any collision while running independent tests in parallel.

### New tests

Come up with a CPython module that's interesting (typically ones with a C
  implementation in `cpython/Modules/`).  Write a brief test case that operates
  on a `bytesliteral` specified by `b'@'`.  For example:

    import re
    data = b'@'
    pat = re.compile(data)

    content = b'''Lorem ipsum dolor sit amet, consectetur adipisicing elit,
    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
    ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur
    sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
    mollit anim id est laborum.'''

    pat.search(content)

Let's put this one in `tests/testrepat/testrepat.py`.  Also, it's important
to note that your test should not preserve any state from run to run.  Could
the library under test cache the `data` input value?  If so, you should try
to bar that behavior or find a way to purge it in order to minimize its
interference on subsequent iterations.

Unfortunately for now, defining tests requires a bit of repetition.  We'll
work on some makefile magic that can abstract out some of those details
to simplify making new test cases.  But as it stands now, you've got to add
your case to `tests/build/_tests.mk`: add it to `TEST_EXECS`, create a `testrepat` binary and make sure it's in the `vpath %.py`.

e.g.

    testrepat: testrepat.o $(EXEC_OBJS)

    ...

    vpath %.py ../testfoo/:../testbar/:../testrepat/

#### Seeds
The fuzzer is pretty clever, but it's best to start out with a few
interesting seed cases to get the ball rolling.

Put some files in `tests/testrepat/inputs/` that represent sane or nearly-sane
input data that will end up taking the place of the `bytesliteral`
"`b'@'`" in the program.
e.g.

    echo "\d{4,5}" > tests/testrepat/inputs/some_digits
    echo "[A-Z]+" > tests/testrepat/inputs/some_alpha

If your test can leverage a set of tokens as inputs, put them as
newline-delimited content in `tests/<testname>/<testname>.tok`.

e.g.

    echo -e '+\n-\n/\n*' > tests/testrepat/testrepat.tok


The fuzzer will perturb these inputs in one of a few different transforms,
watching how the resulting program executes.  It will continue to iterate and
focus on the input values which drive the untested frontier further.

## Trophy case
* http://bugs.python.org/issue25388
