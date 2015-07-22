#include <stdlib.h>
#include <memory>

#include <Python.h>
#include "pywrap.h"

extern "C" char _binary_src_py_start;
extern "C" char _binary_src_py_end;
extern "C" char _binary_src_py_size;

PyWrap src_wrapper(static_cast<const char *>(&_binary_src_py_start),
        reinterpret_cast<size_t>(&_binary_src_py_size));

extern "C" void LLVMFuzzerTestOneInput(const unsigned char *data, unsigned long size)
{
  if (size < 1) { return; }

  const std::string source_str = src_wrapper.get_source(data, size);

  Py_Initialize();
  PyRun_SimpleString(source_str.c_str());
  Py_Finalize();
}
