
try:
    from urllib.parse import urlparse
except ImportError:
    from urlparse import urlparse

p = urlparse(b'data:@')
