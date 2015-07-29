#!/usr/bin/env python

from dbm import gnu as dbm
import tempfile
import os

with tempfile.NamedTemporaryFile(suffix='.db', delete=False) as f:
    f.write(b'@')
    f.close()
    try:
        db = dbm.open(f.name, 'r')
    finally:
        os.unlink(f.name)
