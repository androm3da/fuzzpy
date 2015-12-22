

parser = expat.ParserCreate(None, None)
contents = b'@'
parser.Parse(contents, 0)
parser.Parse(b'', True)
