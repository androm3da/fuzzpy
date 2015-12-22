

from decimal import Decimal, InvalidOperation

try:
    num = Decimal('@')
except InvalidOperation:
    pass
