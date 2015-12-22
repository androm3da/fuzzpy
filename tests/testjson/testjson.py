
import json
text = '@'

try:
    json.loads(text)
except ValueError:
    pass
