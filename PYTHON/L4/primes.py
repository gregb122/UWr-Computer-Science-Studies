from typing import List

from utils import get_function_time_exec_with_result


def generate_primes_collection(number: int) -> List[int]:
    """
    It wraps primes generator into a list of primes with less or equal :arg: `number` value.
    :param number: Maximum possible generated value
    :return: List of primes no bigger than number.
    """
    return [prime_candidate for prime_candidate in range(2, number + 1) if all(list(
        prime_candidate % divider != 0 for divider in range(2, round(prime_candidate ** 0.5) + 1)))]


def generate_primes_collection_func(number: int) -> List[int]:
    """
    This function represents the same functionality as :func: `generate_primes_collection`, but it uses
    functional components instead of list comprehension mechanism.
    """
    return list(filter(lambda prime_candidate: all(list(map(lambda divider: prime_candidate % divider != 0, range(2, round(
        prime_candidate ** 0.5) + 1)))), range(2, number + 1)))


def generate_primes_collection_imperative(number: int) -> List[int]:
    """
    This function represents the same functionality as :func: `generate_primes_collection`, but it uses
    imperative components instead of list comprehension mechanism.
    """
    prime_collection = []
    if number < 2:
        return prime_collection
    divider = 2
    is_prime = True
    for prime_candidate in range(2, number + 1):
        while divider * divider <= prime_candidate:
            if prime_candidate % divider == 0:
                is_prime = False
            divider += 1
        if is_prime:
            prime_collection.append(prime_candidate)
        divider = 2
        is_prime = True

    return prime_collection


VALUES = [200000, ]

print("List comprehension:")
for number in VALUES:
    print(get_function_time_exec_with_result(generate_primes_collection, number))

print("Functional:")
for number in VALUES:
    print(get_function_time_exec_with_result(generate_primes_collection_func, number))

print("Imperative:")
for number in VALUES:
    print(get_function_time_exec_with_result(generate_primes_collection_imperative, number))
