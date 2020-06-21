import pytest

import num2words as ref_num2words
from L1.num_to_words_converter import convert

NUMBERS = [0, 1, 8, 15, 23, 45, 87, 90, 100, 101, 113, 186, 546, 1000, 1001, 1012, 1032, 3456,
           8500, 10013, 22001, 34575, 60640, 100002, 101010, 103202, 200413, 600012, 1000000, 1001000, 1010100, 200453,
           10000000, 10101010, 10001000, 20001012, 30230010, 50340100, 7000000, 85430020, 99999999]


@pytest.mark.parametrize("number", NUMBERS)
def test_num2words(number):
    """
    E2e test with reference official num2words package frm PyPi
    """
    exp = ref_num2words.num2words(number=number, lang="pl")
    tested = convert(number)
    # bug in ref sample app
    if "dziewięćdzisiąt" in exp:
        exp = exp.replace("dziewięćdzisiąt", "dziewięćdziesiąt")
    assert tested == exp, f"Tested: {tested} <> Exp: {exp}"
