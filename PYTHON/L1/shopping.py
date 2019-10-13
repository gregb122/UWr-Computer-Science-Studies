DENOMINATIONS = [20, 10, 5, 2, 1]
PRINTER_DENOMINATIONS_MAP = {
    20: "dwudziestoma złotymi",
    10: "dziesięcioma złotymi",
    5: "pięcioma złotymi",
    2: "dwoma złotymi",
    1: "złotówką",
}


def get_denominations_map(total: int) -> dict:
    """
    Calculates the most effective combination of bill payment under amount of denominations criteria.
    :param total: Value associated with summary shopping cost.
    :return: Map which contains what denominations and what amount of them should be used for payment
    """
    denominations_map = {denomination: 0 for denomination in DENOMINATIONS}
    for denomination in DENOMINATIONS:
        while denomination <= total:
            denominations_map[denomination] += 1
            total -= denomination
    return denominations_map


def print_payment_details(denominations_map: dict):
    """
    Print denominations with amounts in desirable way.
    :param denominations_map: Map associated with returns of :py:func:`get_denominations_map`
    """
    payment_details = "Zapłać: "
    denominations_map = {denomination: amount for denomination, amount in denominations_map.items() if amount > 0}
    for denomination, amount in sorted(denominations_map.items(), key=lambda x: x[0]):
        payment_details += f"{amount} x {PRINTER_DENOMINATIONS_MAP[denomination]} "
    print(payment_details)


def pay_bill(total):
    """
    Pay your total cost of bill using the least of amount of your denominations.
    :param total: Value associated with summary shopping cost.
    """
    bill_payment_solution = get_denominations_map(total)
    print_payment_details(bill_payment_solution)


pay_bill(1)
pay_bill(3)
pay_bill(8)
pay_bill(43)
pay_bill(100)
pay_bill(123)
