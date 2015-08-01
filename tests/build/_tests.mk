
###################
# libFuzzer
###################
VPATH+=$(LLVM_SRC)/llvm/lib/Fuzzer/
FUZZ_OBJS= \
    FuzzerCrossOver.o \
    FuzzerDriver.o \
    FuzzerInterface.o \
    FuzzerIO.o \
    FuzzerMain.o \
    FuzzerMutate.o \
    FuzzerSanitizerOptions.o \
    FuzzerSHA1.o \
    FuzzerTraceState.o \
    FuzzerUtil.o \
    FuzzerLoop.o \
    $()

EXEC_OBJS+= \
    $(FUZZ_OBJS) 
    $()

###################
# wrapper code:
###################
COMPILE_FLAGS+=-I../../wrapper/
VPATH+=../../wrapper
EXEC_OBJS+= \
    pywrap.o \
    pyconsole.o \
    tester.o \
    $()

TEST_EXECS:= \
    testplist \
    testjson \
    testxmlrpc \
    testbz2 \
    testpy \
    testsqlite_query \
    $()

# TODO: testdbm temporarily disabled because it does exit(1) when it gets scared
#testbin: testplist testjson testxmlrpc testbz2 testdbm testpy testsqlite_query
testbin: $(TEST_EXECS)

TEST_OBJS=$(foreach t,$(TEST_EXECS),$(t).o)

testplist: testplist.o $(EXEC_OBJS)
testjson: testjson.o $(EXEC_OBJS)
testxmlrpc: testxmlrpc.o $(EXEC_OBJS)
testbz2: testbz2.o $(EXEC_OBJS)
testdbm: testdbm.o $(EXEC_OBJS)
testpy: testpy.o $(EXEC_OBJS)
testsqlite_query: testsqlite_query.o $(EXEC_OBJS)

#vpath %.py $(foreach t, $(TEST_EXECS), ../$(t):) 
vpath %.py ../testplist/:../testjson:../testbz2/:../testxmlrpc/:../testdbm/:../testpy/:../testsqlite_query/



clean::
	$(RM) $(TEST_EXECS) $(TEST_OBJS)
