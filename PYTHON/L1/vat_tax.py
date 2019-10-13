TAX_RATE = 0.23
NDIGITS = 4


def vat_invoice(netto_prices):
    return sum(netto_prices) * TAX_RATE


def var_receipt(netto_prices):
    return sum([netto_price * TAX_RATE for netto_price in netto_prices])


list_of_prices = [0.2, 0.5, 4.59, 6]
print(vat_invoice(list_of_prices))
print(var_receipt(list_of_prices))
