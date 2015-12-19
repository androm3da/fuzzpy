
THIS_FILE=${BASH_SOURCE}
THIS_DIR_=$(dirname ${THIS_FILE})
# get abs path:
THIS_DIR=$(readlink -f ${THIS_DIR_})
INSTALL_PREFIX=${THIS_DIR}/fuzzpy_install/

# for cpython and our fuzzing exec:
SANITIZE_OPTS="-fsanitize=address"
SANITIZE_COV_OPTS="-fsanitize-coverage=edge,indirect-calls" 

DEBUG_OPTS="-g -fno-omit-frame-pointer"

PROCS=$(grep -c ^processor /proc/cpuinfo)

#TODO: so far this still requires a manual step to 
#   flip the git repo to 2.x.  e.g. "git checkout 2.7; git update"
PYVER=3

