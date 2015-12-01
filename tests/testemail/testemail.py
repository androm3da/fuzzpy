
try:
    from email import message_from_bytes as parser
except ImportError:
    from email import message_from_string as parser

text = b'@'
result = parser(text)
