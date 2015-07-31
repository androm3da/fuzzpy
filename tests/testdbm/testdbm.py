#!/usr/bin/env python

from dbm import gnu as dbm
import tempfile
import os

FIELDS = (
    b'NOT',
    b'Python:',
    b'',
    b'REALLY',
    b'intended',
    b'THERE',
)
with tempfile.NamedTemporaryFile(suffix='.db', delete=False, dir='/dev/shm') as f:
    f.write(b'@')
    f.close()
    try:
        db = dbm.open(f.name, 'r')
        for f in FIELDS: 
            x = db.get(f, None)

    finally:
        os.unlink(f.name)
