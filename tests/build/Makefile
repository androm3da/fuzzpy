
.PHONY: all clean

all: testbin

include ./_tests.mk

SANCOV=-fsanitize-coverage=bb,indirect-calls,8bit-counters
SAN=-fsanitize=address
SAN_FLAGS=$(SAN) $(SANCOV)

COMPILE_FLAGS+=-g -fno-omit-frame-pointer -std=c++11

PKG_CONFIG_PATH=$(INSTALL_PREFIX)/lib/pkgconfig

LDLIBS=-lstdc++ -lutil
LDLIBS+=-Xlinker -export-dynamic $(shell PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" pkg-config --libs python)
COMPILE_FLAGS+=$(shell PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" pkg-config --cflags python)

LDFLAGS+=$(SAN) -pthread
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
