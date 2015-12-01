#!/usr/bin/env python
from __future__ import print_function

import os
import os.path

def run_test(contents, input_file):
     with open(input_file, 'rb') as f:
         input_data = bytearray(f.read())

     input_data_encoded = ''.join([r'\x{:02x}'.format(x) for x in input_data])

     new_contents = contents.replace('@', input_data_encoded)
#    print('new contents', new_contents)

     try:
         exec(new_contents)
     except Exception as e:
         pass

def run_tests(sourcefile, input_path):
    with open(sourcefile, 'rt') as f:
        contents = f.read()

    if os.path.isdir(input_path):
        for input_file in os.listdir(input_path):
            run_test(contents, os.path.join(input_path, input_file))
    else:
        run_test(contents, input_path)

if __name__ == '__main__':
    import sys
    run_tests(sys.argv[1], sys.argv[2])
