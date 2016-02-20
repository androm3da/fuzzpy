
import plistlib
from xml.parsers.expat import ExpatError

try:
    from plistlib import InvalidFileException
except ImportError:
    class InvalidFileException(Exception): pass

text = b'@'

try:
	if 'loads' in dir(plistlib):
		plistlib.loads(text)
	else:
		plistlib.readPlistFromString(text)
except UnicodeDecodeError:
	pass # TODO: this is probably not an effective test case
except ExpatError:
	pass
except InvalidFileException:
	pass
except ValueError:
	pass
except AttributeError:
	pass
