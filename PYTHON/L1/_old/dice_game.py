import random

from typing import Generator


def throw_dice() -> int:
    """
    Represents throwing dice action.
    :return: Result of single throw.
    """
    random_number = random.randint(1, 6)
    return random_number


def play_turn(end_game: bool = False) -> Generator:
    """
    It plays one turn of game. Every player throws two dices and adds results into his score.
    :param end_game: End game indicator which stops game.
    :return: Current player scores.
    """
    player1_score, player2_score = 0, 0
    played_turn = 0

    while not end_game:
        played_turn += 1

        print(f"Turn {played_turn}:")

        player1_throw = throw_dice() + throw_dice()
        player2_throw = throw_dice() + throw_dice()

        print("Player 1 sum:", player1_throw)
        print("Player 2 sum:", player2_throw)

        if player1_throw > player2_throw:
            player1_score += 1

        elif player1_throw < player2_throw:
            player2_score += 1

        print("Player 1 won:", player1_score, "turns")
        print("Player 2 won:", player2_score, "turns")

        print()

        yield player1_score, player2_score


def play_game(number_of_turns: int):
    """
    Throw dices and play until to win/lose.
    :param number_of_turns: Maximum game turns value.
    """
    player1_score, player2_score = 0, 0
    turn = play_turn()

    if number_of_turns < 1:
        print("The game not started!")
        return

    for _ in range(number_of_turns):
        player1_score, player2_score = next(turn)

    while player1_score == player2_score:
        player1_score, player2_score = next(turn)

    play_turn(end_game=True)
    print("The game is finished!")


play_game(4)


