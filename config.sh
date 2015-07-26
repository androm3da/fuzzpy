
THIS_FILE=${BASH_SOURCE}
THIS_DIR=$(dirname ${THIS_FILE})
INSTALL_PREFIX=${THIS_DIR}/fuzzpy_install/

# for cpython and our fuzzing exec:
SANITIZE_OPTS="-fsanitize=address -fno-sanitize=leak"
SANITIZE_COV_OPTS="-fsanitize-coverage=bb,indirect-calls,8bit-counters"
DEBUG_OPTS="-g -fno-omit-frame-pointer"

PROCS=$(grep -c ^processor /proc/cpuinfo)

#TODO: so far this still requires a manual step to 
#   flip the git repo to 2.x.  e.g. "git checkout 2.7; git update"
PYVER=3

