#!/usr/bin/env python

import sqlite3

try:
    conn = sqlite3.connect(':memory:')
    c = conn.execute(b'@')
except:
    pass
finally:
    conn.close()
