#!/bin/sh

# TODO: follow up w/CPython and/or llvm team on 'leaks' (or 
#    create suppressions)
ASAN_OPTIONS=detect_leaks=0
export ASAN_OPTIONS

export PATH=${INSTALL_PREFIX}/bin:$PATH
CLANG=${INSTALL_PREFIX}/bin/clang

# for cpython and our fuzzing exec:
SANITIZE_OPTS="-fsanitize=address"
SANITIZE_COV_OPTS="-fsanitize-coverage=bb,indirect-calls,8bit-counters"
DEBUG_OPTS="-g -fno-omit-frame-pointer"

INSTALL_PREFIX=${PWD}/fuzzpy_install/
LLVM_SRC=${PWD}/llvm_src/
LLVM_BUILD=${PWD}/llvm_build/
TEST_SRC=${PWD}/tests/

CPY_SRC=${PWD}/cpython/
CPY_BUILD=${CPY_SRC}

build_clang()
{
    cd ${LLVM_BUILD}

    cmake  \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_CXX_COMPILER=clang++ \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=X86 \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=type \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        ${LLVM_SRC}/llvm

    make -j2
    make install
    cd -
}

build_cpython()
{
    cd ${CPY_BUILD}

    PYCFLAGS="${SANITIZE_OPTS} ${SANITIZE_COV_OPTS} ${DEBUG_OPTS}"
    CC=${CLANG} \
       CXX=${CLANG}++ \
       CFLAGS="${PYCFLAGS}" \
       CXXFLAGS="${PYCFLAGS}" \
       LDFLAGS="${SANITIZE_FLAGS}" \
       ./configure --with-pydebug --disable-ipv6 --prefix=${INSTALL_PREFIX}

    make -j2
    ASAN_OPTION=detect_leaks=0 make install
}

build_tests()
{
    cd ${TEST_SRC}/build/
    make INSTALL_PREFIX=${INSTALL_PREFIX} CC=${CLANG} CXX=${CLANG}++ SAN=${SANITIZE_OPTS}
}

build_clang
build_cpython
build_tests
