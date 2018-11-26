{-# LANGUAGE Safe #-}

module Interpreter_v2 (typecheck, eval) where

import AST
import DataTypes
---------------------------------------------------------------------------------------
----------------------CZESC_PIERWSZA_FUNKCJA_TYPECHECK---------------------------------
---------------------------------------------------------------------------------------

typecheck :: (Show p) => [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck fe listofvars program = case (check_fenv fe fe) of
                                    Nothing -> Error (getData program) "Function Environment - internal mismatched types occurs"
                                    Just result -> to_final_format (mytypecheck (from_func_to_funvenv fe) (from_vars_to_env listofvars) program) program

-- zamiana listy zmiennych na postac srodowiska
from_vars_to_env:: [Var] -> [(Var,Type)]
from_vars_to_env [] = []
from_vars_to_env (var:restofvars) = (var, TInt):(from_vars_to_env restofvars)

-- zamiana wewnetrznego formatu na wyjsciowy format TypeCheckResult
to_final_format:: (Show p) => MyTypeResult p -> Expr p -> TypeCheckResult p
to_final_format result program =
        case (result) of
          MOk (TInt) -> Ok
          MError (p, msg) -> Error p msg
          MOk (_) -> Error (getData program) "Cannot match expression type into expected final type: Integer"

-- zamiana listy definicji funkcji na srodowisko funkcji
from_func_to_funvenv:: [FunctionDef p] -> [(FSym, FunctionDef p)]
from_func_to_funvenv [] = []
from_func_to_funvenv (x:xs) = ((funcName x),x):(from_func_to_funvenv xs)

-- funkcja sprawdzajaca poprawnosc typow srodowiska funkcji
check_fenv:: (Show p) => [FunctionDef p] -> [FunctionDef p] -> Maybe [FunctionDef p]
check_fenv _ [] = Just []
check_fenv x (fe:frest) = case (mytypecheck (from_func_to_funvenv x) [(funcArg fe, funcArgType fe)] (funcBody fe) ) of
                            MOk (typ2) -> case ((funcResType fe) == typ2) of
                                    True -> check_fenv x frest
                                    False -> Nothing
                            MError (p, msg) -> Nothing

---------------------------------------------------------------------------------------
----------------------DEFINICJE TYPOW DANYCH-------------------------------------------
---------------------------------------------------------------------------------------
data MyTypeResult p = MOk (Type) | MError (p, String) deriving (Show,Eq)
---------------------------------------------------------------------------------------
----------------------FUNKCJA_WEWNETRZNA: mytypecheck----------------------------------
---------------------------------------------------------------------------------------

mytypecheck:: (Show p) => [(FSym, FunctionDef p)] -> [(Var, Type)] -> Expr p -> MyTypeResult p

-------------REGULY_TYPOWANIA:::-------------------------------------------------------
---------------------------------------------------------------------------------------
----------------------STALE------------------------------------------------------------
---------------------------------------------------------------------------------------

-- I. Stala typu Integer
mytypecheck fe env (ENum p n) = MOk (TInt)

-- II. Stala typu Bool
mytypecheck fe env (EBool p b) = MOk (TBool)

-- III. Stala typu Unit
mytypecheck fe env (EUnit p) = MOk (TUnit)
---------------------------------------------------------------------------------------
----------------------ZMIENNE----------------------------------------------------------
---------------------------------------------------------------------------------------

-- I. Zmienne
mytypecheck fe env (EVar p x) =
  case lookup x env of
      Just typ -> MOk (typ)
      Nothing ->  MError (p, "Error: Undefined Variable")

---------------------------------------------------------------------------------------
----------------------REGULY_ARYTMETYCZNE_DLA_WYRAZEN_TYPU_INTEGER---------------------
---------------------------------------------------------------------------------------
-- I. dodawanie
mytypecheck fe env (EBinary p BAdd e1 e2) =
   case (mytypecheck fe env e1) of
      MOk (TInt) -> case (mytypecheck fe env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2 ,msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (+) operation")
      MError (llp, msg) -> MError (llp, msg)

-- II. odejmowanie
mytypecheck fe env (EBinary p BSub e1 e2) =
   case (mytypecheck fe env e1) of
      MOk (TInt) -> case (mytypecheck fe env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (-) operation")
      MError (llp, msg) -> MError (llp, msg)

-- III. mnozenie
mytypecheck fe env (EBinary p BMul e1 e2) =
    case (mytypecheck fe env e1) of
      MOk (TInt) -> case (mytypecheck fe env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (*) operation")
      MError (llp, msg) -> MError (llp, msg)

-- IV. dzielenie
mytypecheck fe env (EBinary p BDiv e1 e2) =
    case (mytypecheck fe env e1) of
      MOk (TInt) -> case (mytypecheck fe env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (`div`) operation")
      MError (llp, msg) -> MError (llp, msg)

-- V. Modulo
mytypecheck fe env (EBinary p BMod e1 e2) =
    case (mytypecheck fe env e1) of
      MOk (TInt) -> case (mytypecheck fe env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (`mod`) operation")
      MError (llp, msg) -> MError (llp, msg)

-- VI. minus
mytypecheck fe env (EUnary p UNeg e1) =
    case (mytypecheck fe env e1) of
      MOk (TInt) -> MOk (TInt)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (-) operation")
      MError (llp, msg) -> MError (llp, msg)

---------------------------------------------------------------------------------------
----------------------REGULY_BOOLEOWSKIE_DLA_WYRAZEN_TYPU_BOOL-------------------------
---------------------------------------------------------------------------------------

-- I. And
mytypecheck fe env (EBinary p BAnd e1 e2) =
    case (mytypecheck fe env e1) of
      MOk (TBool) -> case (mytypecheck fe env e2) of
                        MOk (TBool) -> MOk (TBool)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (and) operation")
      MError (llp, msg) -> MError (llp, msg)

-- II. Or
mytypecheck fe env (EBinary p BOr e1 e2) =
    case (mytypecheck fe env e1) of
      MOk (TBool) -> case (mytypecheck fe env e2) of
                        MOk (TBool) -> MOk (TBool)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (or) operation")
      MError (llp, msg) -> MError (llp, msg)

-- III. Not
mytypecheck fe env (EUnary p UNot e1) =
  case (mytypecheck fe env e1) of
    MOk (TBool) -> MOk (TBool)
    MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (not) operation")
    MError (llp2, msg) -> MError (llp2 ,msg)

---------------------------------------------------------------------------------------
----------------------REGULY_BOOLEOWSKIE_DLA_WYRAZEN_TYPU_INT--------------------------
---------------------------------------------------------------------------------------

-- I. Rownosc
mytypecheck fe env (EBinary p BEq e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- II. Wieksze niz
mytypecheck fe env (EBinary p BGt e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (>) operation")
    MError (llp, msg) -> MError (llp, msg)

-- III. Mniejsze niz
mytypecheck fe env (EBinary p BLt e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<) operation")
    MError (llp, msg) -> MError (llp, msg)

-- IV. Wieksze rowne niz
mytypecheck fe env (EBinary p BGe e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (>=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- V. Mniejsze rowne niz
mytypecheck fe env (EBinary p BLe e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- VI. Rozne
mytypecheck fe env (EBinary p BNeq e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (TInt) -> case (mytypecheck fe env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<>) operation")
    MError (llp, msg) -> MError (llp, msg)

---------------------------------------------------------------------------------------
----------------------REGULY_DLA_WYRAZEN_IF_THEN_ELSE_ORAZ_LET-------------------------
---------------------------------------------------------------------------------------
-- I. Wyrazenie if____then____else
mytypecheck fe env (EIf p e1 e2 e3) =
  case (mytypecheck fe env e1) of
    MOk (TBool) -> case (mytypecheck fe env e2) of
                       MOk (TInt) -> case (mytypecheck fe env e3) of
                                          MOk (TInt) -> MOk (TInt)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TBool) -> case (mytypecheck fe env e3) of
                                          MOk (TBool) -> MOk (TBool)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TList a1) -> case (mytypecheck fe env e3) of
                                          MOk (TList a2) -> case (a2 == a1) of
                                                              True -> MOk (TList a1)
                                                              False -> MError (p, "TypeError: Mismatched internal list types")
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: List -> Non-List")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TPair a1 a2) -> case (mytypecheck fe env e3) of
                                          MOk (TPair a3 a4) -> case (a3 == a1 && a4 == a2) of
                                                               True -> MOk (TPair a1 a2)
                                                               False -> MError (p, "TypeError: Mismatched internal pair types")
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Pair -> Non-Pair")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TUnit) -> case (mytypecheck fe env e3) of
                                          MOk (TUnit) -> MOk (TUnit)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Unit -> Non-Unit")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Expected type for (if) condition structure: Bool")
    MError (llp, msg) -> MError (llp, msg)

-- II. Wyrazenie let
mytypecheck fe env (ELet p x e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (mytype) -> case (mytypecheck fe ((x, mytype):env) e2) of
                       MOk (mytype) -> MOk (mytype)
                       MError (llp1, msg) -> MError (llp1, msg)
    MError (llp, msg) -> MError (llp, msg)

--------------------------------------------------------------------------------------------------------
---------------------------------REGULY_TYPOWANIA_NOWE_PRAC_5-------------------------------------------
--------------------------------------------------------------------------------------------------------
-- regula typowania dla aplikowania argumentu do funkcji

mytypecheck fe env (EApp p fsym e) =
  case (lookup fsym fe) of
    Just fun -> case mytypecheck fe env e of
                  MOk t1 -> case (t1 == funcArgType fun) of
                            True -> MOk (funcResType fun)
                            False -> MError (p, "TypeError: Mismatched argument type")
                  MError (llp2, msg) -> MError (llp2, msg)
    Nothing -> MError (p, "Undefined function definition")

-- regula typowania dla konstruktora listy niepustej
mytypecheck fe env (ECons p e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (t1) -> case (mytypecheck fe env e2) of
              MOk (TList a1) -> case (a1 == t1) of
                                True -> MOk (TList t1)
                                False -> MError (p, "TypeError: Mismatched internal types")
              MOk (_) -> MError (p, "TypeError: Non-list type")
              MError (llp2, msg) -> MError (llp2, msg)
    MError (llp2, msg) -> MError (llp2, msg)

-- regula typowania dla konstruktora listy pustej
mytypecheck fe env (ENil p t) =
  case (t) of
    TList t2 -> MOk (TList t2)
    TPair t1 t2 -> MError (p,"TypeError: Non-list type")
    TBool -> MError (p,"TypeError: Non-list type")
    TInt -> MError (p,"TypeError: Non-list type")
    TUnit -> MError (p,"TypeError: Non-list type")

-- regula typowania dla konstruktora pary
mytypecheck fe env (EPair p e1 e2) =
  case (mytypecheck fe env e1) of
    MOk (a1) -> case (mytypecheck fe env e2) of
                MOk (a2) -> MOk (TPair a1 a2)
                MError (llp2, msg) -> MError (llp2, msg)
    MError (llp1, msg) -> MError (llp1, msg)

-- regula typowania dla konstruktora fst pary
mytypecheck fe env (EFst p e1) =
  case (mytypecheck fe env e1) of
    MOk (TPair a1 a2) -> MOk (a1)
    MOk (_) -> MError (p, "TypeError: Illegal operation for non-pair types")
    MError (llp2, msg) -> MError (llp2, msg)

-- regula typowania dla konstruktora snd pary
mytypecheck fe env (ESnd p e1) =
  case (mytypecheck fe env e1) of
    MOk (TPair a1 a2) -> MOk (a2)
    MOk (_) -> MError (p, "TypeError: Illegal operation for non-pair types")
    MError (llp2, msg) -> MError (llp2, msg)

-- regula typowania dla dopasowania do wzorca
mytypecheck fe env (EMatchL p e1 n1 (x1, x2, e2)) =
  case (mytypecheck fe env e1) of
    MOk (TList a1) -> case (mytypecheck fe env n1) of
                          MOk (a2) -> case (mytypecheck fe ((x1,a1):(x2,TList a1):env) e2) of
                                      MOk (a3) -> case (a3 == a2) of
                                              True -> MOk (a2)
                                              False -> MError (p, "Mismatched internal types")
                                      MError (llp2, msg) -> MError (llp2, msg)
                          MError (llp, msg) -> MError (llp, msg)
    MOk (_) -> MError (p, "TypeErrorL Illegal operation for non- list types")
    MError (llp, msg) -> MError (llp, msg)


---------------------------------------------------------------------------------------
----------------------CZESC_DRUGA_FUNKCJA_EVAL-----------------------------------------
---------------------------------------------------------------------------------------

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval fe env program = to_eval_result_type (myeval (from_func_to_funvenv fe) (to_new_environment env) program)

-- zamiana poczatkowego typu srodowiska na wewnetrzny typ srodowiska dla myValue
to_new_environment:: [(Var,Integer)] -> [(Var,MyValue)]
to_new_environment [] = []
to_new_environment ((x,n):xs) = (x, N n):to_new_environment xs

-- zamiana koncowego typu zwracanej wartosci przez myeval na EvalResult
to_eval_result_type:: Maybe MyValue -> EvalResult
to_eval_result_type result =
  case result of
    Just (N n) -> Value n
    Nothing -> RuntimeError

---------------------------------------------------------------------------------------
----------------------DEFINICJE TYPOW DANYCH-------------------------------------------
---------------------------------------------------------------------------------------
data MyValue =
 N Integer
 | TF Bool
 | L [MyValue]
 | P (MyValue, MyValue)
 | U
  deriving (Show)

---------------------------------------------------------------------------------------
----------------------FUNKCJA_WEWNETRZNA: myeval---------------------------------------
---------------------------------------------------------------------------------------

myeval :: [(FSym, FunctionDef p)] -> [(Var, MyValue)] -> Expr p -> Maybe MyValue

---------------------------------------------------------------------------------------
----------------------STALE------------------------------------------------------------
---------------------------------------------------------------------------------------

-- I. stala typu Integer
myeval fe env (ENum p n) =
   Just (N n)

-- II. stala typu Bool
myeval fe env (EBool p b)
    | b == True = Just (TF True)
    | b == False = Just (TF False)
    | otherwise = Nothing

-- III. stala typu Unit
myeval fe env (EUnit p) = Just (U)

---------------------------------------------------------------------------------------
----------------------ZMIENNE----------------------------------------------------------
---------------------------------------------------------------------------------------

-- I. Zmienne
myeval fe env (EVar p x) =
  case lookup x env of
       Just (n) -> Just (n)
       Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------REGULY_ARYTMETYCZNE_DLA_WYRAZEN_TYPU_INTEGER---------------------
---------------------------------------------------------------------------------------
-- I. dodawanie
myeval fe env (EBinary p BAdd e1 e2) =
   case (myeval fe env e1) of
      Just (N n1) -> case (myeval fe env e2) of
                      Just (N n2) -> Just (N (n1 + n2))
                      Nothing -> Nothing
      Nothing -> Nothing

-- II. odejmowanie
myeval fe env (EBinary p BSub e1 e2) =
  case (myeval fe env e1) of
     Just (N n1) -> case (myeval fe env e2) of
                     Just (N n2) -> Just (N (n1 - n2))
                     Nothing -> Nothing
     Nothing -> Nothing


-- III. mnozenie
myeval fe env (EBinary p BMul e1 e2) =
  case (myeval fe env e1) of
     Just (N n1) -> case (myeval fe env e2) of
                     Just (N n2) -> Just (N (n1 * n2))
                     Nothing -> Nothing
     Nothing -> Nothing

-- IV. dzielenie
myeval fe env (EBinary p BDiv e1 e2) =
    case (myeval fe env e1) of
      Just (N n1) -> case (myeval fe env e2) of
                      Just (N 0) -> Nothing
                      Just (N n2) -> Just (N (n1 `div` n2))
                      Nothing -> Nothing
      Nothing -> Nothing

--V. modulo
myeval fe env (EBinary p BMod e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N 0) -> Nothing
                    Just (N n2) -> Just (N (n1 `mod` n2))
                    Nothing -> Nothing
    Nothing -> Nothing

--VI. minus
myeval fe env (EUnary p UNeg e1) =
    case (myeval fe env e1) of
      Just (N n1) -> Just (N (-n1))
      Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------REGULY_BOOLEOWSKIE_DLA_WYRAZEN_TYPU_BOOL-------------------------
---------------------------------------------------------------------------------------

-- I. And
myeval fe env (EBinary p BAnd e1 e2) =
    case (myeval fe env e1) of
      Just (TF b1) -> case (myeval fe env e2) of
                        Just (TF b2) -> Just (TF (b1 && b2))
                        Nothing -> Nothing
      Nothing -> Nothing

-- II. Or
myeval fe env (EBinary p BOr e1 e2) =
  case (myeval fe env e1) of
    Just (TF b1) -> case (myeval fe env e2) of
                      Just (TF b2) -> Just (TF (b1 || b2))
                      Nothing -> Nothing
    Nothing -> Nothing

-- III. Not
myeval fe env (EUnary p UNot e1) =
    case (myeval fe env e1) of
      Just (TF b1) -> Just (TF (not (b1)))
      Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------REGULY_BOOLEOWSKIE_DLA_WYRAZEN_TYPU_INT/BOOL---------------------
---------------------------------------------------------------------------------------

-- I. Rownosc
myeval fe env (EBinary p BEq e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 == n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- II. Wieksze niz
myeval fe env (EBinary p BGt e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 > n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- II. Mniejsze niz
myeval fe env (EBinary p BLt e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 < n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- III. Wieksze równe niz
myeval fe env (EBinary p BGe e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 >= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- IV. Mniejsze równe niz
myeval fe env (EBinary p BLe e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 <= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- V. Rozne
myeval fe env (EBinary p BNeq e1 e2) =
  case (myeval fe env e1) of
    Just (N n1) -> case (myeval fe env e2) of
                    Just (N n2) -> Just (TF (n1 /= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------REGULY_DLA_WYRAZEN_IF_THEN_ELSE_ORAZ_LET-------------------------
---------------------------------------------------------------------------------------

-- I. Wyrazenie if____then____else
myeval fe env (EIf p e1 e2 e3) =
  case (myeval fe env e1) of
    Just (TF True) -> myeval fe env e2
    Just (TF False) -> myeval fe env e3
    Nothing -> Nothing

-- II. Wyrazenie let_____in______
myeval fe env (ELet p x e1 e2) =
  case (myeval fe env e1) of
    Just (n) -> myeval fe ((x, n):env) e2
    Nothing -> Nothing

----------------------------------------------------------------------------------------
-------------------NOWE_REGULY_DLA_WYRAZEN_PRACOWNIA_5----------------------------------
----------------------------------------------------------------------------------------

-- I. Wyrazenie dla wywolania (aplikacji argumentu) funkcji
myeval fe env (EApp p fsym e) =
  case (myeval fe env e) of
    Just (v1) -> case (lookup fsym fe) of
                  Just (v2) -> case (myeval fe [((funcArg v2),v1)] (funcBody v2)) of
                                Just (v3) -> Just (v3)
                                Nothing -> Nothing
                  Nothing -> Nothing
    Nothing -> Nothing

-- II. Wyrazenie dla konstruktora listy niepustej
myeval fe env (ECons p e1 e2) =
  case (myeval fe env e1) of
    Just (v0) -> case (myeval fe env e2) of
                  Just (v1) -> Just (L (v0:[v1]))
                  Nothing -> Nothing
    Nothing -> Nothing

-- III. Wyrazenie dla konstruktora listy pustej
myeval fe env (ENil p t) =
  case (t) of
    (TList t2) -> Just (L ([]))
    _ -> Nothing

-- IV. Wyrazenie dla konstruktora pary
myeval fe env (EPair p e1 e2) =
  case (myeval fe env e1) of
    Just (v1) -> case (myeval fe env e2) of
                  Just (v2) -> Just (P (v1,v2))
                  Nothing -> Nothing
    Nothing -> Nothing

-- V. Wyrazenie dla konstruktora fst pary
myeval fe env (EFst p e1) =
  case (myeval fe env e1) of
    Just (P (v1,v2)) -> Just (v1)
    Nothing -> Nothing

-- VI. Wyrazenie dla konstruktora snd pary
myeval fe env (ESnd p e1) =
  case (myeval fe env e1) of
    Just (P (v1,v2)) -> Just (v2)
    Nothing -> Nothing

-- VII. wyrazenie dla dopasowania do wzorca
myeval fe env (EMatchL p e1 n1 (x1, x2, e2)) =
  case (myeval fe env e1) of
    Just (L ([])) -> case (myeval fe env n1) of
                      Just (v) -> Just (v)
                      Nothing -> Nothing
    Just (L (v0:[v1])) -> case (myeval fe ((x1,v0):(x2,v1):env) e2) of
                            Just (v3) -> Just (v3)
                            Nothing -> Nothing
    Nothing -> Nothing
