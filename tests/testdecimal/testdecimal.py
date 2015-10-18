

from decimal import Decimal, InvalidOperation

try:
    num = Decimal(b'@')
except InvalidOperation:
    pass
