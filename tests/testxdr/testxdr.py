import xdrlib

text = b'@'
u = xdrlib.Unpacker(text)
try:
    while True:
        u.unpack_uint()
except EOFError:
    pass
    
u = xdrlib.Unpacker(text)
try:
    while True:
        u.unpack_string()
except EOFError:
    pass
    
