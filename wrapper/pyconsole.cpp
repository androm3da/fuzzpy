
#include <Python.h>
#include "pyconsole.h"

extern "C" PyObject* out_noop(PyObject* self, PyObject* args)
{
    return Py_BuildValue("");
}

static PyMethodDef methods[] =
{
    {"write", out_noop, METH_VARARGS, "..."},
    {"flush", out_noop, METH_VARARGS, "..."},
    {0, 0, 0, 0},
};

static PyModuleDef pyconsole_module =
{
    PyModuleDef_HEAD_INIT,
    "pyconsole",
    "...",
    -1,
    methods,
};

PyMODINIT_FUNC PyInit_pyconsole()
{
    PyObject* o = PyModule_Create(&pyconsole_module);
    PySys_SetObject("stdout", o);
    PySys_SetObject("stderr", o);

    return o;
}

PyConsole::PyConsole()
{
    PyImport_AppendInittab("pyconsole", PyInit_pyconsole);
}

void PyConsole::import()
{
    PyImport_ImportModule("pyconsole");
}
