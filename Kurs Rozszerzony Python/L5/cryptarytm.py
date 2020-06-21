from itertools import permutations


class Cryptarytm:
    """
    Crypt-a-rytm game:
    Example:
      KIOTO      41373
    + OSAKA    + 32040
    ------- -> -------
      TOKIO      73413
    Crypt-a-rytm requirements :
    * Up to 10 different capitalized letters
    * Should have EXACTLY ONE proper solution
    """

    def __init__(self, primary_word: str, secondary_word: str, result_word: str):
        self.word_1st = primary_word
        self.word_2nd = secondary_word
        self.result_word = result_word
        self.solution = {}

    def solve(self):
        """
        Generates all permutations and checks each of them for being potential solution.
        """
        # extract total amount of different letters from all words
        letters = set(list(f"{self.word_1st}{self.word_2nd}{self.result_word}"))

        # padding word which differs amount of letters
        if len(self.word_1st) < len(self.word_2nd):
            self.word_1st = "_" * (len(self.word_2nd) - len(self.word_1st)) + self.word_1st
        elif len(self.word_1st) > len(self.word_2nd):
            self.word_2nd = "_" * (len(self.word_1st) - len(self.word_2nd)) + self.word_2nd

        for permutation in permutations(range(10), len(letters)):
            solution_candidate = {"_": 0}
            solution_candidate.update({letter: number for letter, number in zip(letters, permutation)})
            if self._calculate_cryptarytm_for_solution_candidate(solution_candidate):
                self.solution = solution_candidate

    def print_solution(self):
        """
        This printer perform projection of summing operation within paper.
        """
        row = []
        for letter in self.word_1st:
            if letter != "_":
                row.append(str(self.solution[letter]))
            else:
                row.append(" ")

        row = "".join(row)
        print(" " * 4, row)
        row = []
        for letter in self.word_2nd:
            if letter != "_":
                row.append(str(self.solution[letter]))
            else:
                row.append(" ")
        row = "".join(row)
        print(" " * 3 + "+", row)
        row = []
        print(" " * 4, "-" * len(self.result_word))
        for letter in self.result_word:
            row.append(str(self.solution[letter]))
        row = "".join(row)
        print(" " * 4, row)

    def _calculate_cryptarytm_for_solution_candidate(self, solution_candidate: dict):
        """
        Perform cryptarytm calculation for generated permutation with check.
        :param solution_candidate:   Single permutation generated for cryptarytm check
        :return: Answer if it's a solution or not
        """
        borrowed_value = 0
        for up_letter, down_letter, result_letter in list(zip(self.word_1st, self.word_2nd, self.result_word))[::-1]:
            operation_result = solution_candidate[up_letter] + solution_candidate[down_letter] + borrowed_value
            if borrowed_value > 0:
                borrowed_value -= 1
            if operation_result < 9:
                if operation_result != solution_candidate[result_letter]:
                    return False
            else:
                operation_result %= 10
                borrowed_value += 1
                if operation_result != solution_candidate[result_letter]:
                    return False
        return True


puzzle_word_1 = Cryptarytm(primary_word="KIOTO", secondary_word="OSAKA", result_word="TOKIO")
puzzle_word_1.solve()
puzzle_word_1.print_solution()
print()

puzzle_word_2 = Cryptarytm(primary_word="KTO", secondary_word="KOT", result_word="TOK")
puzzle_word_2.solve()
puzzle_word_2.print_solution()
print()

puzzle_word_3 = Cryptarytm(primary_word="KOGUT", secondary_word="KURA", result_word="JAJKO")
puzzle_word_3.solve()
puzzle_word_3.print_solution()
print()
