from utils import get_function_time_exec_with_result
from typing import List, Tuple


def generate_amicable_numbers_collection(number: int) -> List[Tuple[int, int]]:
    """
    It wraps amicable pairs of numbers generator into a list of amicable number pairs.
    :param number: Maximum possible generated value.
    :return: List of primes no bigger than number.
    """
    return [(amicable_candidate_1st, amicable_candidate_2nd)
            for amicable_candidate_1st in range(1, number)
            for amicable_candidate_2nd in [sum(divider_1st + amicable_candidate_1st // divider_1st for divider_1st in
                                               range(1, round(amicable_candidate_1st ** 0.5) + 1)
                                               if amicable_candidate_1st % divider_1st == 0) - amicable_candidate_1st]
            if sum(divider_2nd + amicable_candidate_2nd // divider_2nd
                   for divider_2nd in range(1, round(amicable_candidate_2nd ** 0.5) + 1)
            if amicable_candidate_2nd % divider_2nd == 0) - amicable_candidate_2nd == amicable_candidate_1st
            and amicable_candidate_1st < amicable_candidate_2nd <= number]


def generate_amicable_numbers_collection_func(number: int) -> List[Tuple[int, int]]:
    """
    This function represents the same functionality as :func: `generate_amicable_numbers_collection`, but it uses
    functional components instead of list comprehension mechanism.
    """
    int_and_dividers_sum = map(
        lambda x: sum(map(
            lambda z: z + x // z,
            filter(lambda y: x % y == 0, range(1, round(x ** 0.5) + 1)))) - x,
        range(1, number))

    divider_sum_of_dividers_sum = filter(
        lambda t: sum(map(lambda s: s + t[1] // s, filter(
            lambda w: t[1] % w == 0,
            range(1, round(t[1] ** 0.5) + 1)))) - t[1] == t[0],
        enumerate(int_and_dividers_sum, 1))

    return list(filter(lambda t: t[0] < t[1] <= number, divider_sum_of_dividers_sum))


print("List comprehension:", get_function_time_exec_with_result(generate_amicable_numbers_collection, 67000))
print("Functional:", get_function_time_exec_with_result(generate_amicable_numbers_collection_func, 67000))
