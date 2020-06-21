PRINTER_SYMBOL = "#"


def romb(n: int):
    """
    Printer for romb figure using graphical symbol '#'
    :param n: Value associated with romb size.
              Used by printing formula to decide how many rows should be printed
    """
    amount_of_symbol, printing_formula = 1, 2*n + 1
    ascending = True
    for row in range(printing_formula + 1):
        padding = (printing_formula - amount_of_symbol) // 2
        print(" " * padding + PRINTER_SYMBOL * amount_of_symbol + " " * padding)
        if amount_of_symbol < printing_formula and ascending:
            amount_of_symbol += 2
        else:
            if amount_of_symbol == printing_formula and ascending:
                ascending = False
            amount_of_symbol -= 2


romb(4)
romb(5)
romb(8)
