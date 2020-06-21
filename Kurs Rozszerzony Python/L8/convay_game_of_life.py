from typing import List

import matplotlib.pyplot as plt
import matplotlib.animation as animation
import random
import numpy as np
from copy import deepcopy

ROW_SIZE = 100
COLUMN_SIZE = 100

board = [[0 for row in range(ROW_SIZE)] for col in range(COLUMN_SIZE)]


def initialize_board():
    """
    Fill 2D board (list of lists) with random boolean values (1, 0)
    """
    for row_index in range(ROW_SIZE):
        for col_index in range(COLUMN_SIZE):
            board[row_index][col_index] = random.randrange(100) % 2


def play_turn():
    """
    Calculate each cell value in order to game rules
    """
    board_snapshot = deepcopy(board)

    for row_index in range(ROW_SIZE):
        for col_index in range(COLUMN_SIZE):
            board[row_index][col_index] = set_cell_value(row_index, col_index, board_snapshot)


def set_cell_value(row_index: int, col_index: int, board_snapshot: List[List[int]]) -> int:
    """
    Calculate next turn value for cell in order to following rules:
    * if cell has 1 or less neighbours or has 4 and more, should be set on 0 in the next turn
    * if cell has exactly 3 neighbours, should be set on 1 in the next turn
    * if cell has exactly 2 neighbours, should preserve current value in the next turn

    :param row_index:       First coord of cell location
    :param col_index:       Second coord of cell location
    :param board_snapshot:  A copy of board being freezed status from the beginning of current turn
    :return:                Calculated cell value in the next turn.
    """
    neighbours_count = 0
    neighbours = [
        (row_index - 1, col_index - 1), (row_index, col_index - 1), (row_index + 1, col_index - 1),  # left
        (row_index - 1, col_index), (row_index + 1, col_index),  # center
        (row_index - 1, col_index + 1), (row_index, col_index + 1), (row_index + 1, col_index + 1)  # right
    ]
    # match neighbours inside board only
    neighbours = [(row_index, col_index) for row_index, col_index in neighbours
                  if ROW_SIZE > row_index >= 0 and COLUMN_SIZE > col_index >= 0]

    for row, col in neighbours:
        neighbours_count += board_snapshot[row][col]

    if neighbours_count > 3 or neighbours_count < 2:
        board[row_index][col_index] = 0

    elif neighbours_count == 3:
        board[row_index][col_index] = 1

    return board[row_index][col_index]


def update_board(data):
    """
    Bind board data structure to the handler of image object.
    :param data:    Required by FuncAnimation
    :return:        Optional, animation object
    """
    nrows, ncols = ROW_SIZE, COLUMN_SIZE
    image = np.zeros(nrows * ncols)
    image = image.reshape((nrows, ncols))

    play_turn()
    for row_index in range(ROW_SIZE):
        for col_index in range(COLUMN_SIZE):
            image[row_index, col_index] = board[row_index][col_index]

    mat.set_data(image)
    return [mat]


initialize_board()
fig, ax = plt.subplots()
mat = ax.matshow(board)
ani = animation.FuncAnimation(fig, update_board, interval=100, save_count=20)
plt.show()

