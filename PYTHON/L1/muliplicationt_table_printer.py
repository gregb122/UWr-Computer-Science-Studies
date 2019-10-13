def print_multiplication_table(col_min: int, col_max: int, row_min: int, row_max: int):
    """
    It's multiplication table printer.
    :param col_min:     start column value
    :param col_max:     end column value
    :param row_min:     start row value
    :param row_max:     end row value
    """
    # match amount of whitespaces to input data size
    frame_size = len(str(col_max * row_max)) + 2
    left_padding = len(str(col_max))

    # print first row
    line = " " * left_padding
    for i in range(col_min, col_max + 1):
        line += get_formatted_number(i, frame_size)
    print(line)

    # print rest of rows
    for j in range(row_min, row_max + 1):
        line = get_formatted_number(j, left_padding)
        for i in range(col_min, col_max + 1):
            line += get_formatted_number(i * j, frame_size)
        print(line)


def get_formatted_number(number: int, frame_size: int) -> str:
    """
    Returns number as a string with valid padding
    :param number:      number for print
    :param frame_size:  padding value
    :return:            formatted string number
    """
    return " " * (frame_size - len(str(number))) + str(number)


# demo
DEMO_CASES = [[3, 5, 2, 4],
              [1, 10, 6, 13],
              [34, 46, 1, 24], ]

SEPARATE_LINE = "-" * 120

for demo_case in DEMO_CASES:
    print(SEPARATE_LINE)
    print_multiplication_table(*demo_case)
