
###################
# libFuzzer
###################
FUZZ_SRC_DIR=$(LLVM_SRC)/llvm/lib/Fuzzer/
VPATH+=$(FUZZ_SRC_DIR)
FUZZ_LIB=libFuzzer.a

EXEC_OBJS+= \
    $(FUZZ_LIB) \
    $()

###################
# wrapper code:
###################
COMPILE_FLAGS+=-I../../wrapper/
LIBFUZZ_LDLIBS=-stdlib=libc++ -lutil -lc++ -lc++abi
LIBFUZZ_FLAGS=-c -g -O2 -std=c++11 -stdlib=libc++

VPATH+=../../wrapper
EXEC_OBJS+= \
    pywrap.o \
    pyconsole.o \
    tester.o \
    $()

TEST_EXECS:= \
    testplist \
    testjson \
    testbz2 \
    testpy \
    testsqlite_query \
    testxdr \
    testurlparse \
    testint \
    testemail \
    testdecimal \
    $()

# TODO: testdbm temporarily disabled because it does exit(1) when it gets scared
#testbin: testplist testjson testxmlrpc testbz2 testdbm testpy testsqlite_query
testbin: $(TEST_EXECS)

TEST_OBJS=$(foreach t,$(TEST_EXECS),$(t).o)

testplist: testplist.o $(EXEC_OBJS)
testjson: testjson.o $(EXEC_OBJS)
testbz2: testbz2.o $(EXEC_OBJS)
testpy: testpy.o $(EXEC_OBJS)
testsqlite_query: testsqlite_query.o $(EXEC_OBJS)
testxdr: testxdr.o $(EXEC_OBJS)
testurlparse: testurlparse.o $(EXEC_OBJS)
testdecimal: testdecimal.o $(EXEC_OBJS)
testint: testint.o $(EXEC_OBJS)
testemail: testemail.o $(EXEC_OBJS)

FUZZ_SRCS=$(wildcard $(FUZZ_SRC_DIR)/Fuzzer*.cpp)
$(FUZZ_LIB):
	clang++ $(LIBFUZZ_FLAGS) $(FUZZ_SRCS)
	ar ruv $@ Fuzzer*.o

#vpath %.py $(foreach t, $(TEST_EXECS), ../$(t):)
vpath %.py ../testplist/:../testjson:../testbz2/: \
					 ../testpy/:../testsqlite_query/:../testxdr/:../testurlparse/: \
					 ../testint/:../testemail/:../testdecimal/



clean::
	$(RM) $(TEST_EXECS) $(TEST_OBJS)
