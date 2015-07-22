#ifndef PYWRAP_H
#define PYWRAP_H

#include <vector>
#include <string>

class PyWrap
{
    public:
//      const std::string DELIM("@@@");
        const char DELIM = '@';

        PyWrap(const char *start, size_t length);
        std::string get_source(const unsigned char *data, unsigned long size);

    protected:
        static std::vector<std::string> &split(const std::string &s, 
                char delim, 
                std::vector<std::string> &elems);

        std::string prefix;
        std::string suffix;
};

#endif /* PYWRAP_H */
