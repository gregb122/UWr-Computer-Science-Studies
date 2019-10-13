import functools


def memoize(func):
    """
    Generic Python wrapper for memoization technique
    :param func: Pointer to function should be wrapped
    :return:
    """
    cache = func.cache = {}
    @functools.wraps(func)
    def memoized_func(*args, **kwargs):
        key = str(args) + str(kwargs)
        if key not in cache:
            cache[key] = func(*args, **kwargs)
        return cache[key]
    return memoized_func


@memoize
def sudan(n: int, x: int, y: int) -> int:
    """
    Sudan function which recursion tree grows rapidly for enough high x, y. Not recommended use with n > 2 due to
    enormous growth of stack. Perfect example for memoization technique understood.

    :return:    Sudan function result
    """
    if n == 0:
        return x + y
    if y == 0:
        return x
    return sudan(n-1, sudan(n, x, y-1), sudan(n, x, y-1) + y)


print(sudan(1, 4, 7))
print(sudan(1, 24, 103))
print(sudan(1, 342, 143))

