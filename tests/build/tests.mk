
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
    tester.o \
    $()


testbin: testplist testjson testxmlrpc testbz2

testplist: testplist.o $(EXEC_OBJS)
testjson: testjson.o $(EXEC_OBJS)
testxmlrpc: testxmlrpc.o $(EXEC_OBJS)
testbz2: testbz2.o $(EXEC_OBJS)

vpath %.py ../testplist/:../testjson:../testbz2/:../testxmlrpc/



clean::
	$(RM) testplist{,.o} testjson{,.o} testxmlrpc{,.o} testbz2{,.o}
