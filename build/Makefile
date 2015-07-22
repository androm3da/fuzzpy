
all: testbin

SAN=-fsanitize-coverage=bb,indirect-calls,8bit-counters
COMPILE_FLAGS+=-g -fno-omit-frame-pointer -std=c++11

SAN_FLAGS+= -fsanitize=address $(SAN)
LDLIBS=-lstdc++ -lutil

LDLIBS+=-Xlinker -export-dynamic $(shell pkg-config --libs python2)
COMPILE_FLAGS+=$(shell pkg-config --cflags python2)

COMPILE_FLAGS+=-I../wrapper/

LDFLAGS+=$(SAN_FLAGS) -pthread
CFLAGS+=$(CPPPATH) $(SAN_FLAGS) $(COMPILE_FLAGS) -pthread
CXXFLAGS+=$(CPPPATH) $(SAN_FLAGS) $(COMPILE_FLAGS)

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

EXEC_OBJS= \
    $(FUZZ_OBJS) \
    tester.o \
    pywrap.o \
    $()

TESTS=\
    testplist.py \
    $()


VPATH = ../Fuzzer/:../wrapper/:../tests/testplist/:../tests/testjson/:../tests/testbz2/:../tests/testxmlrpc/

testbin: testplist testjson testxmlrpc testbz2

testplist: testplist.o $(EXEC_OBJS)
testjson: testjson.o $(EXEC_OBJS)
testxmlrpc: testxmlrpc.o $(EXEC_OBJS)
testbz2: testbz2.o $(EXEC_OBJS)


define get_bin_name
  _binary_$(shell echo $(1) | tr '.' '_' | tr '/' '_')
endef

OBJCOPY=objcopy

%.o: %.py
	$(OBJCOPY) --input-target binary \
		       --output-target elf64-x86-64 \
		       --binary-architecture i386 \
			   $< tmp.o
	$(OBJCOPY) --redefine-sym $(call get_bin_name, $<)_end=_binary_src_py_end \
			   --redefine-sym $(call get_bin_name, $<)_start=_binary_src_py_start \
			   --redefine-sym $(call get_bin_name, $<)_size=_binary_src_py_size \
			   tmp.o $@

clean:
	$(RM) $(EXEC_OBJS)
