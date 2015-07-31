
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


# TODO: testdbm temporarily disabled because it does exit(1) when it gets scared
#testbin: testplist testjson testxmlrpc testbz2 testdbm testpy testsqlite_query
testbin: testplist testjson testxmlrpc testbz2 testpy testsqlite_query

testplist: testplist.o $(EXEC_OBJS)
testjson: testjson.o $(EXEC_OBJS)
testxmlrpc: testxmlrpc.o $(EXEC_OBJS)
testbz2: testbz2.o $(EXEC_OBJS)
testdbm: testdbm.o $(EXEC_OBJS)
testpy: testpy.o $(EXEC_OBJS)
testsqlite_query: testsqlite_query.o $(EXEC_OBJS)

vpath %.py ../testplist/:../testjson:../testbz2/:../testxmlrpc/:../testdbm/:../testpy/:../testsqlite_query/



clean::
	$(RM) testplist{,.o} testjson{,.o} testxmlrpc{,.o} testbz2{,.o} testdbm{,.o} testpy{,.o} testsqlite_query{,.o}
