
import bz2
text = b'@'

try:
    bz2.decompress(text)
except OSError:
    pass
except ValueError:
    pass
