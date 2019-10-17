from typing import List

from utils import get_function_time_exec_with_result


def generate_perfect_numbers_collection(number: int) -> List[int]:
    """
    It wraps perfect number generator into a list of perfect numbers with less or equal :arg: `number` value.
    :param number: Maximum possible generated value
    :return: List of primes no bigger than number.
    """
    return [perfect_candidate for perfect_candidate in range(1, number)
            if sum(divider for divider in range(1, perfect_candidate // 2 + 1)
                   if perfect_candidate % divider == 0) == perfect_candidate]


def generate_perfect_numbers_collection_func(number: int) -> List[int]:
    """
    This function represents the same functionality as :func: `generate_perfect_numbers_collection`, but it uses
    functional components instead of list comprehension mechanism.
    """
    return list(filter(lambda perfect_candidate: perfect_candidate == sum(
        divider for divider in range(1, perfect_candidate // 2 + 1)
        if perfect_candidate % divider == 0), range(1, number)))


def generate_perfect_numbers_collection_imperative(number: int) -> List[int]:
    """
    This function represents the same functionality as :func: `generate_perfect_numbers_collection`, but it uses
    imperative components instead of list comprehension mechanism.
    """
    perfect_num_collection = []
    div_sum = 0
    for perfect_candidate in range(1, number):
        for divider in range(1, perfect_candidate // 2 + 1):
            if perfect_candidate % divider == 0:
                div_sum += divider

        if div_sum == perfect_candidate:
            perfect_num_collection.append(perfect_candidate)
        div_sum = 0
    return perfect_num_collection


print("List_comprehension:", get_function_time_exec_with_result(generate_perfect_numbers_collection, 10000))
print("Functional:", get_function_time_exec_with_result(generate_perfect_numbers_collection_func, 10000))
print("Imperative:", get_function_time_exec_with_result(generate_perfect_numbers_collection_imperative, 10000))
