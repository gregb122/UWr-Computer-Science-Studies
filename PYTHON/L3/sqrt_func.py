import unittest
from math import floor


def custom_sqrt(n: int) -> int:
    """
    Custom implementation of floor(n ** 0.5).
    :param n: Integer
    :return: floor(n ** 0.5)
    """
    if n < 0:
        raise ValueError(f"Sqrt value error: {n} < 0")
    elif n == 0:
        return 0
    k = 1
    result = 0
    while k * k <= n:
        result += 2*k - 1
        k += 1
    return result // (k - 1)


print(custom_sqrt(4))
print(custom_sqrt(24))
print(custom_sqrt(121))


class CustomSqrt(object):
    def __init__(self):
        self.test_values = [2, 3, 4, 15, 25, 32, 49, 78, 100]


class TestCustomSqrt(unittest.TestCase):

    def setUp(self) -> None:
        super(TestCustomSqrt, self).setUp()
        self.test_values = CustomSqrt().test_values

    def test_zero_value(self) -> None:
        self.assertEqual(custom_sqrt(0), 0)

    def test_negative_value(self) -> None:
        with self.assertRaises(ValueError):
            custom_sqrt(-32)

    def test_specified_values(self) -> None:
        for value in self.test_values:
            self.assertEqual(custom_sqrt(value), floor(value ** 0.5))

