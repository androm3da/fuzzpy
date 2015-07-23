
.PHONY: all clean

all: testbin

include ./tests.mk

SANCOV=-fsanitize-coverage=bb,indirect-calls,8bit-counters
SAN=-fsanitize=address
SAN_FLAGS=$(SAN) $(SANCOV)

COMPILE_FLAGS+=-g -fno-omit-frame-pointer -std=c++11

PKG_CONFIG_ARGS=$(INSTALL_PREFIX)/lib/pkgconfig/python.pc python
LDLIBS=-lstdc++ -lutil
LDLIBS+=-Xlinker -export-dynamic $(shell pkg-config --libs $(PKG_CONFIG_ARGS))
COMPILE_FLAGS+=$(shell pkg-config --cflags $(PKG_CONFIG_ARGS))

LDFLAGS+=$(SAN_FLAGS) -pthread
CFLAGS+=$(CPPPATH) $(SAN_FLAGS) $(COMPILE_FLAGS) -pthread
CXXFLAGS+=$(CPPPATH) $(SAN_FLAGS) $(COMPILE_FLAGS)

TESTS=\
    testplist.py \
    $()

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

clean::
	$(RM) $(EXEC_OBJS)
