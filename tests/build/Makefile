
.PHONY: all clean

all: testbin

include ./_tests.mk

SANCOV=-fsanitize-coverage=edge,indirect-calls
SAN=-fsanitize=address
SAN_FLAGS=$(SAN) $(SANCOV)

COMPILE_FLAGS+=-g -fno-omit-frame-pointer -O2 -std=c++11

PKG_CONFIG_PATH=$(INSTALL_PREFIX)/lib/pkgconfig

LDLIBS=-stdlib=libc++ -lutil -lc++ -lc++abi
LDLIBS+=-Xlinker -export-dynamic $(shell PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" pkg-config --libs python3)
COMPILE_FLAGS+=-stdlib=libc++
COMPILE_FLAGS+=$(shell PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" pkg-config --cflags python3)

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
OUTPUT_TARGET:=$(shell objcopy -i 2>&1 |grep 'supported targets:' | cut -f 4 -d ' ')
ifeq ($(shell arch),armv7l)
  BINARCH:=arm7
else ifeq ($(shell arch),i686)
  BINARCH:=i386
else ifeq ($(shell arch),x86_64)
  BINARCH:=i386
else
  BINARCH:=UNDEFINED
endif

%.o: %.py
	$(OBJCOPY) --input-target binary \
		       --output-target $(OUTPUT_TARGET) \
		       --binary-architecture $(BINARCH) \
			   $< tmp.o
	$(OBJCOPY) --redefine-sym $(call get_bin_name, $<)_end=_binary_src_py_end \
			   --redefine-sym $(call get_bin_name, $<)_start=_binary_src_py_start \
			   --redefine-sym $(call get_bin_name, $<)_size=_binary_src_py_size \
			   tmp.o $@

clean::
	$(RM) $(EXEC_OBJS)
	$(RM) tmp.o
