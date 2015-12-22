
text = b'@'
try:
    compile(text, '<string:{}>'.format(text), 'exec')
except Exception:
    pass
    
