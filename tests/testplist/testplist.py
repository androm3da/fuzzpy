
import plistlib
from xml.parsers.expat import ExpatError

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
except plistlib.InvalidFileException:
	pass
except ValueError:
	pass
