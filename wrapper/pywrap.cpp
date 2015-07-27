
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include "pywrap.h"
#include <Python.h>

/**
 * Encodes the data as a python hex-escaped string
 * might expect, e.g. '\x03\x4a\x34\xf3'
 */
static std::string to_hex(const unsigned char *data, unsigned long size)
{
    std::ostringstream ss;
    for (unsigned long i = 0; i < size; i++)
    {
        const unsigned char *byte = data + i;
        ss << "\\x" << std::setfill('0') << std::setw(2) << std::hex << static_cast<int>(*byte);
    }
    return ss.str();
}

#include <string>
#include <sstream>
#include <vector>
#include <stdexcept>


PyWrap::PyWrap(const char *start, size_t length)
    :prefix(),
     suffix()
{
    const std::string src_str(start, length);

    std::vector<std::string> elems;
    split(src_str, DELIM, elems);

    if (elems.size() != 2)
    {
        throw std::runtime_error("Err: expected 2 fields separated by '@'");
    }
    prefix = elems[0];
    suffix = elems[1];

}

std::string PyWrap::get_source(const unsigned char *data, unsigned long size)
{
    return prefix + to_hex(data, size) + suffix;
}


std::vector<std::string> &PyWrap::split(const std::string &s,
        char delim,
        std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

