import itertools

from abc import ABC, abstractmethod
from typing import List


class Formula(ABC):
    """
    Base class for boolean logic formulas.
    """
    def is_tautology(self, variables: List[str]) -> bool:
        """
        Tautology check means if formula is always true for every possible evaluation.
        :param variables: List of variables included in formula
        :return: Tautology check result as a boolean value
        """
        return all(self.evaluate(values_map) for values_map in self._generate_all_evaluations_map(variables))

    @abstractmethod
    def evaluate(self, evaluation_map: dict) -> bool:
        """
        Must be implemented in each subclass.
        :param evaluation_map:
        :return:
        """
        pass

    def __str__(self):
        to_str = self.to_str()
        if to_str.startswith('(') and to_str.endswith(')'):
            to_str = to_str[1:-1]
        return to_str

    @staticmethod
    def _generate_all_evaluations_map(values_list):
        generated_values = itertools.product([False, True], repeat=len(values_list))
        return [{key: value for key, value in zip(values_list, generated_value)} for generated_value in generated_values]

    @abstractmethod
    def to_str(self) -> str:
        """
        Must be implemented in each subclass. Example:
        1. Impl(Not(Var("u")), Var("x"))   ==>    ~u => x
        :return:    Formula representation in string
        """
        pass


class Equiv(Formula):
    def __init__(self, l_expr, r_expr):
        self.l_expr = l_expr
        self.r_expr = r_expr

    def evaluate(self, evaluation_map):
        return not (self.l_expr.evaluate(evaluation_map) ^ self.r_expr.evaluate(evaluation_map))

    def to_str(self):
        return f"({self.l_expr.to_str()} <=> {self.r_expr.to_str()})"


class Impl(Formula):
    def __init__(self, l_expr, r_expr):
        self.l_expr = l_expr
        self.r_expr = r_expr

    def evaluate(self, evaluation_map):
        return not self.l_expr.evaluate(evaluation_map) or self.r_expr.evaluate(evaluation_map)

    def to_str(self):
        return f"({self.l_expr.to_str()} => {self.r_expr.to_str()})"


class And(Formula):
    def __init__(self, l_expr, r_expr):
        self.l_expr = l_expr
        self.r_expr = r_expr

    def evaluate(self, evaluation_map):
        return self.l_expr.evaluate(evaluation_map) and self.r_expr.evaluate(evaluation_map)

    def to_str(self):
        return f"({self.l_expr.to_str()} ^ {self.r_expr.to_str()})"


class Or(Formula):
    def __init__(self, l_expr, r_expr):
        self.l_expr = l_expr
        self.r_expr = r_expr

    def evaluate(self, evaluation_map):
        return self.l_expr.evaluate(evaluation_map) or self.r_expr.evaluate(evaluation_map)

    def to_str(self):
        return f"({self.l_expr.to_str()} v {self.r_expr.to_str()})"


class Var(Formula):
    def __init__(self, literal):
        self.literal = literal

    def evaluate(self, evaluation_map):
        return evaluation_map[self.literal]

    def to_str(self):
        return f"{self.literal}"


class Not(Formula):
    def __init__(self, l_expr):
        self.l_expr = l_expr
        super(Not, self).__init__()

    def evaluate(self, evaluation_map):
        return not self.l_expr.evaluate(evaluation_map)

    def to_str(self):
        return f"~{self.l_expr.to_str()}"


class F(Formula):
    def __init__(self):
        super(F, self).__init__()

    def evaluate(self, evaluation_map):
        return False

    def to_str(self):
        return "false"


class T(Formula):
    def __init__(self):
        super(T, self).__init__()

    def evaluate(self, evaluation_map):
        return True

    def to_str(self):
        return "true"


# predefined value
values = {
    "x": True,
    "y": False,
    "z": True,
    "u": False,
    "s": True,
}

# examples
f0 = F()  # false, False
f1 = Var("s")  # s, True
f2 = T()  # true, True
f3 = Impl(Not(Var("u")), Var("x"))  # ~u => x, True
f4 = Impl(Var("x"), Not(And(Var("y"), Impl(Var("z"), T()))))  # x => (~(y ^ (z => true))), True
f5 = Equiv(Impl(And(Var("x"), Or(Var("s"), F())), T()), Not(Var("z")))  # ((x ^ s v false) => true)  <=> ~z, False
f6 = Not(Impl(Var("u"), Var("x")))  # ~(u => x), False
f7 = Equiv(Var("x"), Var("x"))  # tautology, True
f8 = Or(Var("y"), Not(Var("y")))  # tautology, True

print("EVALUATION:")
print(f0.evaluate(values))  # False
print(f1.evaluate(values))  # True
print(f2.evaluate(values))  # True
print(f3.evaluate(values))  # True
print(f4.evaluate(values))  # True
print(f5.evaluate(values))  # False
print(f6.evaluate(values))  # False

print("TAUTOLOGY CHECK:")
print(f0.is_tautology(list(values.keys())))  # False
print(f1.is_tautology(list(values.keys())))  # False
print(f2.is_tautology(list(values.keys())))  # True
print(f3.is_tautology(list(values.keys())))  # False
print(f4.is_tautology(list(values.keys())))  # False
print(f5.is_tautology(list(values.keys())))  # False
print(f6.is_tautology(list(values.keys())))  # False
print(f7.is_tautology(list(values.keys())))  # False
print(f8.is_tautology(list(values.keys())))  # False

print("TO STRING CHECK:")
print(f0)
print(f1)
print(f2)
print(f3)
print(f4)
print(f5)
print(f6)
print(f7)
print(f8)
