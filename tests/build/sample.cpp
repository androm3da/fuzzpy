
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>

extern "C" int LLVMFuzzerTestOneInput(const unsigned char *data,
  unsigned long size);

int main(int argc, const char *argv[])
{
    std::ifstream inFile;
    inFile.open(argv[1]);

    std::stringstream strStream;
    strStream << inFile.rdbuf();
    const std::string contents = strStream.str();

    return LLVMFuzzerTestOneInput(reinterpret_cast<const unsigned char *>(contents.c_str()),
            contents.length());
}
