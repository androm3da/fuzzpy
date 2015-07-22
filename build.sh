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
PYCFLAGS="${SANITIZE_OPTS} ${SANITIZE_COV_OPTS} ${DEBUG_OPTS}"

#TODO: have a better way to control this behavior:
PYVER=3
INSTALL_PREFIX=/opt/fuzzpy
LLVM_SRC=${PWD}/llvm_src/
LLVM_BUILD=${PWD}/llvm_build/

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
    cd -
}

build_cpython()
{

    CC=${CLANG} \
       CXX=${CLANG}++ \
       CFLAGS="${PYCFLAGS}" \
       CXXFLAGS="${PYCFLAGS}" \
       LDFLAGS="${SANITIZE_FLAGS}" \
       ./configure --with-pydebug --disable-ipv6 --prefix=${INSTALL_PREFIX}

    make -j2
    sudo sh -c 'ASAN_OPTION=detect_leaks=0 make install'
}

build_tests()
{
    cd ${TEST_SRC}
    make PYVER=${PYVER} CC=${CLANG} CXX=${CLANG}++
}

build_clang
build_cpython
build_tests
