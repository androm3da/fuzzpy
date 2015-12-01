
import plistlib
text = b'@'
if 'loads' in dir(plistlib):
	plistlib.loads(text)
else:
	plistlib.readPlistFromString(text)

