#!/bin/bash -x

set -e
set -o pipefail

THIS_FILE=${BASH_SOURCE}
THIS_DIR=$(dirname ${THIS_FILE})
source ${THIS_DIR}/config.sh

[[ ${PROCS} -gt 3 ]] && MAKEJOBS=$((${PROCS} - 2)) || MAKEJOBS=2
if [[ ${MAKEJOBS} -gt 16 ]]; then
    MAKEJOBS=16
fi

# TODO: follow up w/CPython and/or llvm team on 'leaks' (or 
#    create suppressions)
ASAN_OPTIONS=detect_leaks=0
export ASAN_OPTIONS

export PATH=${INSTALL_PREFIX?}/bin:$PATH
CLANG=${INSTALL_PREFIX}/bin/clang
#CLANG=clang

LLVM_SRC=${PWD}/llvm_src/
LLVM_BUILD=${LLVM_SRC}/build/
TEST_SRC=${PWD}/tests/

CPY_SRC=${PWD}/cpython/
CPY_BUILD=${CPY_SRC}

build_clang()
{
    cd ${LLVM_SRC}/llvm/tools
    ln -sf ../../clang
    cd ${LLVM_SRC}/llvm/projects
    ln -sf ../../compiler-rt
    mkdir -p ${LLVM_BUILD}
    cd ${LLVM_BUILD}

    case $(arch) in
    x86*)
      TARGET="X86"
      ;;
    armv7*)
      TARGET="ARM"
      ;;
    *)
      TARGET="UNDEFINED"
      ;;
    esac

    CC=${CLANG} CXX=${CLANG}++ cmake  \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD=${TARGET} \
        -G "Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
        ${LLVM_SRC}/llvm

    make -j${MAKEJOBS}
    make install
    cd -
}

build_cpython()
{
    cd ${CPY_BUILD}

    PYCFLAGS="${SANITIZE_OPTS} ${SANITIZE_COV_OPTS} ${DEBUG_OPTS} -Weverything -Wno-padded -Wno-reserved-id-macro"
    CC=${CLANG} \
       CXX=${CLANG}++ \
       CFLAGS="${PYCFLAGS}" \
       CXXFLAGS="${PYCFLAGS}" \
       LDFLAGS="${SANITIZE_OPTS}" \
       ./configure --with-pydebug \
                   --with-address-sanitizer \
                   --disable-ipv6 \
                   --prefix=${INSTALL_PREFIX}

    make -j${MAKEJOBS}
    ASAN_OPTION=detect_leaks=0 make install
    pushd ${INSTALL_PREFIX}/lib/pkgconfig ; ln -sf python${PYVER}.pc python.pc ; popd
    cd -
}

test_cpython()
{
    cd ${CPY_BUILD}
    ASAN_OPTION=detect_leaks=0 make test
    cd -
}

build_tests()
{
    cd ${TEST_SRC}/build/
    make INSTALL_PREFIX=${INSTALL_PREFIX} \
         CC=${CLANG} \
         CXX=${CLANG}++ \
         SAN=${SANITIZE_OPTS} \
         LLVM_SRC=${LLVM_SRC}
    cd -
}

build_clang
build_cpython
#test_cpython
build_tests
