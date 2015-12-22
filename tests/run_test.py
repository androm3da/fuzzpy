#!/usr/bin/env python3
from __future__ import print_function

import os
import os.path


def run_test(contents, input_file):
    with open(input_file, 'rb') as f:
        input_data = bytearray(f.read())

    input_data_encoded = ''.join([r'\x{:02x}'.format(x) for x in input_data])

    new_contents = contents.replace('@', input_data_encoded)
    #    print('new contents', new_contents)

    exec(new_contents)


def run_tests(sourcefile, input_path):
    '''Executes the python source in 'sourcefile' over
        the input at `input_path`.  If `input_path` is a
        directory, we'll iterate over each file within.  If
        `input_path` is a file, we'll execute `sourcefile`
        just once.
    '''
    with open(sourcefile, 'rt') as f:
        contents = f.read()

    if os.path.isdir(input_path):
        for input_file in os.listdir(input_path):
            run_test(contents, os.path.join(input_path, input_file))
    else:
        run_test(contents, input_path)

if __name__ == '__main__':
    import sys
    assert len(sys.argv) >= 3
    for inputs in sys.argv[2:]:

        run_tests(sys.argv[1], inputs)
