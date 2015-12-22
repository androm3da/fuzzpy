#include <stdlib.h>
#include <memory>

#include <Python.h>
#include "pywrap.h"
#include "pyconsole.h"

extern "C" char _binary_src_py_start;
extern "C" char _binary_src_py_end;
extern "C" char _binary_src_py_size;

static PyWrap src_wrapper(static_cast<const char *>(&_binary_src_py_start),
        reinterpret_cast<size_t>(&_binary_src_py_size));

static PyConsole p;

extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data, unsigned long size)
{
  if (size < 1) { return 0; }

  const std::string source_str = src_wrapper.get_source(data, size);

  Py_Initialize();
  p.import();

  const int ret = PyRun_SimpleString(source_str.c_str());
  Py_Finalize();

  return ret;
}
