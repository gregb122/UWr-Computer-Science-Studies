import re
from typing import List, Tuple

WORDS = {
         "0-19": {'0': "", '1': "jeden", '2': "dwa", '3': "trzy", '4': "cztery", '5': "pięć", '6': "sześć",
                  '7': "siedem", '8': "osiem", '9': "dziewięć", '10': "dziesięć", '11': "jedenaście",
                  '12': "dwanaście", '13': "trzynaście", '14': "czternaście", '15': "piętnaście",
                  '16': "szesnaście", '17': "siedemnaście", '18': "osiemnaście", '19': "dziewiętnaście"},

         "10-100": {'0': "", '1': "dziesięć", '2': "dwadzieścia", '3': "trzydzieści", '4': "czterdzieści",
                    '5': "pięćdziesiąt", '6': "sześćdziesiąt", '7': "siedemdziesiąt", '8': "osiemdziesiąt",
                    '9': "dziewięćdziesiąt"},

         "100-1000": {'1': "sto", '2': "dwieście", '3': "trzysta", '4': "czterysta", '5': "pięćset", '6': "sześćset",
                      '7': "siedemset", '8': "osiemset", '9': "dziewięćset", },

         "1000+": {"on": ["tysiąc", "milion", "miliard", "bilion"],
                   "ny": ["tysiące", "miliony", "miliardy", "biliony"],
                   "ów": ["tysięcy", "milionów", "miliadów", "bilionów"],
                   "none": [""] * 4},
        }


def convert(number: int) -> str:
    """
    Convert number into his in-word polish language interpretation.
    :param number:  Examples: 0, 42, 1000
    :return:        Examples: 'zero', 'czterdzieści dwa', 'tysiąc'
    """
    list_of_nums_in_words = []
    if number == 0:
        return "zero"
    if number < 0:
        list_of_nums_in_words, number = preconvert_minus_number(number)

    list_of_digits = prepare_digits_blocks(number)

    if number <= 999:
        list_of_nums_in_words.append(convert_number_from_1_999_range(list_of_digits[0]))
    else:
        list_of_nums_in_words = get_list_of_nums_in_words_more_than_999(list_of_nums_in_words, list_of_digits)

    list_of_nums_in_words = remove_jeden_from_num_in_words_for_thousands(list_of_nums_in_words)

    num_in_words = get_formatted_string_of_num_in_words(list_of_nums_in_words)

    return num_in_words


def preconvert_minus_number(number: int) -> Tuple[List[str], int]:
    """
    For minus number do preprocessing as following:
    1. Change number value into his absolute value (e.g. -43 -> 43)
    2. Add "minus" word indicator for minus value into final list containings words result

    :param      number: Number less than 0
    :return:    "minus" indicator, absolute number value
    """
    return ["minus"], abs(number)


def get_list_of_nums_in_words_more_than_999(list_of_nums_in_words: List[str],
                                            list_of_digits: List[List[str]]) -> List[str]:
    """
    Get words elements for more complex numbers bigger than 999.

    :param list_of_nums_in_words:   List of numbers words
    :param list_of_digits:          List of lists of digit
    :return:                        List of number words with big keywords, e.g. ['dwa', 'tysiące', 'sto', 'jedenaście']
    """
    list_of_big_keywords = add_keywords_for_number_bigger_than_999(list_of_digits)
    for index, digits in enumerate(list_of_digits):
        list_of_nums_in_words.append(convert_number_from_1_999_range(digits))
        if index < len(list_of_big_keywords):
            list_of_nums_in_words.append(list_of_big_keywords[index])
    return list_of_nums_in_words


def get_formatted_string_of_num_in_words(num_in_words: List[str]) -> str:
    """
    Remove any extra spaces and join list of words into a final string result.

    :param num_in_words:    List of word elements, e.g. ['sto', 'jedenaście ']
    :return:                Number in word: 'sto jedenaście'
    """
    num_in_words = " ".join(num_in_words).strip()
    return re.sub(' +', ' ', num_in_words)


def remove_jeden_from_num_in_words_for_thousands(result: List[str]) -> List[str]:
    """
    Remove any extra 'jeden' occurences as a abrupted product of polish language algorithm for building number
    in words.

    :param result:  List of words, e.g. ['jeden', 'tysiąc', 'sto', 'jeden']
    :return:        Filtered list of word, e.g. ['tysiąc', 'sto', 'jeden']
    """
    for index in range(1, len(result)):
        if result[index] in get_word(number='', keyword="1000+", thousands_keyword="on") and result[index-1] == "jeden":
            result[index-1] = ""
    return result


def add_keywords_for_number_bigger_than_999(list_of_digits: List[List[str]]) -> List[str]:
    """
    Get valid big keywords (thousands, milions, bilions, etc) according to list of digits structure.
    Example: For list of digits: [['2'], ['4' ,'3', '2'], ['1', '0', '0']]:
    big_words = ["miliony", "tysiące"]

    :param list_of_digits:  List of lists of digit
    :return:                List with big words
    """
    big_words = []
    keyword_index = len(list_of_digits) - 2
    digits_index = 0
    while keyword_index >= 0:
        thousands_keyword = extract_key_value(list_of_digits[digits_index])
        big_words.append(get_word(number='', keyword="1000+", thousands_keyword=thousands_keyword, index=keyword_index))
        keyword_index -= 1
        digits_index += 1
    return big_words


def extract_key_value(digits: List[str]) -> str:
    """
    Get thousand key value according to regex analysis of digits.
    :param digits:  List of digits, e.g. ['4', '2']
    :return:        Thousand key value for dict with thousands
    """
    number = int("".join(digits))
    if number == 0:
        key = "none"
    elif number == 1:
        key = "on"
    elif re.search("(2|3|4)$", str(number)):
        key = "ny"
    else:
        key = "ów"
    return key


def prepare_digits_blocks(number: int) -> List[List[str]]:
    """
    Splits string number into list of blocks of thousands.
    Examples:
    1. 2034564 -> [['2'], ['0', '3', '4'], ['5', '6', '4']]
    2. 11342 -> [['1', '1'], ['3', '4', '2']]

    :param number: Integer value of number to convert
    :return: List of lists of digits
    """
    list_of_reversed_digits = re.findall(".{1,3}", str(number)[::-1])

    list_of_digits = [list(digits[::-1]) for digits in list_of_reversed_digits[::-1]]

    return list_of_digits


def convert_number_from_1_999_range(digits: List[str]) -> str:
    """
    Convert number from 1-999 into number-in-words.
    :param digits:      List of digits with 1- 3 length (e.g. ['4', '2']
    :return:            Number-in-words (e.g. 'czterdzieści dwa')
    """
    number = int("".join(digits))

    if 0 <= number < 20:
        return get_word(str(number), keyword="0-19")

    elif 20 <= number < 100:
        return get_word(digits[0], keyword="10-100") + " " + convert_number_from_1_999_range(digits[1:])

    else:
        return get_word(digits[0], keyword="100-1000") + " " + convert_number_from_1_999_range(digits[1:])


def get_word(number: str, keyword: str, thousands_keyword: str = None, index: int = None) -> str:
    """
    Get word consistent with number value.
    :param number:              Digit string value
    :param keyword:             First-level key of word dict
    :param thousands_keyword:   Key for dict with thousands word
    :param index:               Index value for selecting proper thousand word
    :return:                    Num in words
    """
    if thousands_keyword is None and index is None:
        return WORDS[keyword][str(number)]

    elif index is None:
        return WORDS[keyword][thousands_keyword]

    return WORDS[keyword][thousands_keyword][index]


print(convert(101))
print(convert(-234323))
print(convert(0))
print(convert(10101010))
