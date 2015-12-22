
import bz2
text = b'@'

try:
    bz2.decompress(text)
except EnvironmentError:
    pass
except ValueError:
    pass
