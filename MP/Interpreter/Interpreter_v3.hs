{-# LANGUAGE Safe #-}
module Interpreter_v3 (typecheck, eval) where
import AST
import DataTypes
-----------------Programming Methods Course 2017-------------------
-----------------Author: Adam Kufel--------------------------------
-----------------Computer Science Studies, 1st Year----------------
-----------------Wroclaw University 2017---------------------------
-----------------Haskell/GHCi--------------------------------------
--Interpreter for functional language made up by course instructors, which includes following features:
-------------------------------------------------------------------
---I.Data Structures Constructs:
-------------------------------------------------------------------
---constant/variable
---list/pair
---lambda expression (->)
---pattern matching (match with)
---function definitions (with HOF support)
-------------------------------------------------------------------
---II. Operator's Constructs:
-------------------------------------------------------------------
---if else construct
---let construct
---int and bool arithmetic (+,-,*,div,mod,and,or,not)
---comparision operations (<,>,<=,>=,<>,==)
---recursion for non-lambda type functions
---------------------------------------------------------------------------------------
----------------------TYPECHECKER--------------------------------------------------------
---------------------------------------------------------------------------------------
-- change function def format into environment type
from_funcdef_to_env:: [FunctionDef p] -> [(Var,Type)]
from_funcdef_to_env [] = []
from_funcdef_to_env (x:xs) = ((funcName x), TArrow (funcArgType x) (funcResType x)):(from_funcdef_to_env xs)

--main typechecker function
typecheck :: (Show p) => [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck fe listofvars program = case (check_fenv fe fe) of
                                    Nothing -> Error (getData program) "Function Environment - internal mismatched types occurs"
                                    Just result -> to_final_format (mytypecheck ((from_vars_to_env listofvars) ++ (from_funcdef_to_env fe)) program) program

-- change list of variables into environment shape
from_vars_to_env:: [Var] -> [(Var,Type)]
from_vars_to_env [] = []
from_vars_to_env (var:restofvars) = (var, TInt):(from_vars_to_env restofvars)

-- to output format conversion
to_final_format:: (Show p) => MyTypeResult p -> Expr p -> TypeCheckResult p
to_final_format result program =
        case (result) of
          MOk (TInt) -> Ok
          MError (p, msg) -> Error p msg
          MOk (_) -> Error (getData program) "Cannot match expression type into expected final type: Integer"

-- verify if input list func definitions is correct
check_fenv:: (Show p) => [FunctionDef p] -> [FunctionDef p] -> Maybe [FunctionDef p]
check_fenv _ [] = Just []
check_fenv fenv (fe:frest) = case (mytypecheck ((funcArg fe, funcArgType fe):(from_funcdef_to_env fenv)) (funcBody fe) ) of
                            MOk (typ2) -> case ((funcResType fe) == typ2) of
                                    True -> check_fenv fenv frest
                                    False -> Nothing
                            MError (p, msg) -> Nothing

---------------------------------------------------------------------------------------
----------------------Data Types Definitions-------------------------------------------
---------------------------------------------------------------------------------------
data MyTypeResult p = MOk (Type) | MError (p, String) deriving (Show,Eq)
---------------------------------------------------------------------------------------
----------------------Internal function mytypecheck------------------------------------
---------------------------------------------------------------------------------------

mytypecheck:: (Show p) => [(Var, Type)] -> Expr p -> MyTypeResult p

-------------Typing Rules:::-----------------------------------------------------------
---------------------------------------------------------------------------------------
----------------------Const------------------------------------------------------------
---------------------------------------------------------------------------------------

-- I. Integer Const
mytypecheck env (ENum p n) = MOk (TInt)

-- II. Boolean Const
mytypecheck env (EBool p b) = MOk (TBool)

-- III. Unit Const
mytypecheck env (EUnit p) = MOk (TUnit)

---------------------------------------------------------------------------------------
----------------------Variables--------------------------------------------------------
---------------------------------------------------------------------------------------
mytypecheck env (EVar p x) =
  case lookup x env of
      Just typ -> MOk (typ)
      Nothing ->  MError (p, "Error: Undefined Variable")

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Arithmetic-------------------------------------
---------------------------------------------------------------------------------------
-- I. Add
mytypecheck env (EBinary p BAdd e1 e2) =
   case (mytypecheck  env e1) of
      MOk (TInt) -> case (mytypecheck  env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2 ,msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (+) operation")
      MError (llp, msg) -> MError (llp, msg)

-- II. Sub
mytypecheck env (EBinary p BSub e1 e2) =
   case (mytypecheck  env e1) of
      MOk (TInt) -> case (mytypecheck  env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (-) operation")
      MError (llp, msg) -> MError (llp, msg)

-- III. Mult
mytypecheck env (EBinary p BMul e1 e2) =
    case (mytypecheck  env e1) of
      MOk (TInt) -> case (mytypecheck  env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (*) operation")
      MError (llp, msg) -> MError (llp, msg)

-- IV. Div
mytypecheck env (EBinary p BDiv e1 e2) =
    case (mytypecheck  env e1) of
      MOk (TInt) -> case (mytypecheck  env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (`div`) operation")
      MError (llp, msg) -> MError (llp, msg)

-- V. Mod
mytypecheck env (EBinary p BMod e1 e2) =
    case (mytypecheck  env e1) of
      MOk (TInt) -> case (mytypecheck  env e2) of
                        MOk (TInt) -> MOk (TInt)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (`mod`) operation")
      MError (llp, msg) -> MError (llp, msg)

-- VI. Minus
mytypecheck env (EUnary p UNeg e1) =
    case (mytypecheck  env e1) of
      MOk (TInt) -> MOk (TInt)
      MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (-) operation")
      MError (llp, msg) -> MError (llp, msg)

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Boolean----------------------------------------
---------------------------------------------------------------------------------------
-- I. And
mytypecheck env (EBinary p BAnd e1 e2) =
    case (mytypecheck  env e1) of
      MOk (TBool) -> case (mytypecheck  env e2) of
                        MOk (TBool) -> MOk (TBool)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (and) operation")
      MError (llp, msg) -> MError (llp, msg)

-- II. Or
mytypecheck env (EBinary p BOr e1 e2) =
    case (mytypecheck  env e1) of
      MOk (TBool) -> case (mytypecheck  env e2) of
                        MOk (TBool) -> MOk (TBool)
                        MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                        MError (llp2 ,msg) -> MError (llp2, msg)
      MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (or) operation")
      MError (llp, msg) -> MError (llp, msg)

-- III. Not
mytypecheck env (EUnary p UNot e1) =
  case (mytypecheck  env e1) of
    MOk (TBool) -> MOk (TBool)
    MOk (_) -> MError (p, "TypeError: Non-Boolean type is illegal for (not) operation")
    MError (llp2, msg) -> MError (llp2 ,msg)

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Comparision------------------------------------
---------------------------------------------------------------------------------------
-- I. Equal
mytypecheck env (EBinary p BEq e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- II. Greather than
mytypecheck env (EBinary p BGt e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (>) operation")
    MError (llp, msg) -> MError (llp, msg)

-- III. Less than
mytypecheck env (EBinary p BLt e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<) operation")
    MError (llp, msg) -> MError (llp, msg)

-- IV. Greather/Equal
mytypecheck env (EBinary p BGe e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (>=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- V. Less/Equal
mytypecheck env (EBinary p BLe e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<=) operation")
    MError (llp, msg) -> MError (llp, msg)

-- VI. Not Equal
mytypecheck env (EBinary p BNeq e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TInt) -> case (mytypecheck  env e2) of
                      MOk (TInt) -> MOk (TBool)
                      MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                      MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Non-Integer type is illegal for (<>) operation")
    MError (llp, msg) -> MError (llp, msg)

---------------------------------------------------------------------------------------
----------------------If/Else and Let constructs---------------------------------------
---------------------------------------------------------------------------------------
-- I.if____then____else
mytypecheck env (EIf p e1 e2 e3) =
  case (mytypecheck  env e1) of
    MOk (TBool) -> case (mytypecheck  env e2) of
                       MOk (TInt) -> case (mytypecheck  env e3) of
                                          MOk (TInt) -> MOk (TInt)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Integer -> Non-Integer")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TBool) -> case (mytypecheck  env e3) of
                                          MOk (TBool) -> MOk (TBool)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Bool -> Non-Boolean")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TList a1) -> case (mytypecheck  env e3) of
                                          MOk (TList a2) -> case (a2 == a1) of
                                                              True -> MOk (TList a1)
                                                              False -> MError (p, "TypeError: Mismatched internal list types")
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: List -> Non-List")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TPair a1 a2) -> case (mytypecheck  env e3) of
                                          MOk (TPair a3 a4) -> case (a3 == a1 && a4 == a2) of
                                                               True -> MOk (TPair a1 a2)
                                                               False -> MError (p, "TypeError: Mismatched internal pair types")
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Pair -> Non-Pair")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TUnit) -> case (mytypecheck  env e3) of
                                          MOk (TUnit) -> MOk (TUnit)
                                          MOk (_) -> MError (p, "TypeError: Mismatched types: Unit -> Non-Unit")
                                          MError (llp1, msg) -> MError (llp1, msg)
                       MOk (TArrow a1 a2) -> case (mytypecheck env e3) of
                                          MOk (TArrow a3 a4) -> case (a1 == a3 && a2 == a4) of
                                                                True -> MOk (TArrow a1 a2)
                                                                False -> MError (p, "TypeError: Mismatched internal functions types")
                                          MOk (_) -> MError (p, "TypeError: Mismatched internal types")
                                          MError (llp2, msg) -> MError (llp2, msg)
                       MError (llp2, msg) -> MError (llp2, msg)
    MOk (_) -> MError (p, "TypeError: Expected type for (if) condition structure: Bool")
    MError (llp, msg) -> MError (llp, msg)

-- II. Let
mytypecheck env (ELet p x e1 e2) =
  case (mytypecheck  env e1) of
    MOk (mytype) -> case (mytypecheck  ((x, mytype):env) e2) of
                       MOk (mytype) -> MOk (mytype)
                       MError (llp1, msg) -> MError (llp1, msg)
    MError (llp, msg) -> MError (llp, msg)

--------------------------------------------------------------------------------------------------------
---------------------------------Lists/Pairs Constructs-------------------------------------------------
--------------------------------------------------------------------------------------------------------
--List
mytypecheck  env (ECons p e1 e2) =
  case (mytypecheck  env e1) of
    MOk (t1) -> case (mytypecheck  env e2) of
              MOk (TList a1) -> case (a1 == t1) of
                                True -> MOk (TList t1)
                                False -> MError (p, "TypeError: Mismatched internal types")
              MOk (_) -> MError (p, "TypeError: Non-list type")
              MError (llp2, msg) -> MError (llp2, msg)
    MError (llp2, msg) -> MError (llp2, msg)

--Empty list
mytypecheck  env (ENil p t) =
  case (t) of
    TList t2 -> MOk (TList t2)
    TPair t1 t2 -> MError (p,"TypeError: Non-list type")
    TBool -> MError (p,"TypeError: Non-list type")
    TInt -> MError (p,"TypeError: Non-list type")
    TUnit -> MError (p,"TypeError: Non-list type")

-- Pair
mytypecheck  env (EPair p e1 e2) =
  case (mytypecheck  env e1) of
    MOk (a1) -> case (mytypecheck  env e2) of
                MOk (a2) -> MOk (TPair a1 a2)
                MError (llp2, msg) -> MError (llp2, msg)
    MError (llp1, msg) -> MError (llp1, msg)

-- fst for Pair
mytypecheck  env (EFst p e1) =
  case (mytypecheck  env e1) of
    MOk (TPair a1 a2) -> MOk (a1)
    MOk (_) -> MError (p, "TypeError: Illegal operation for non-pair types")
    MError (llp2, msg) -> MError (llp2, msg)

-- snd for Pair
mytypecheck  env (ESnd p e1) =
  case (mytypecheck  env e1) of
    MOk (TPair a1 a2) -> MOk (a2)
    MOk (_) -> MError (p, "TypeError: Illegal operation for non-pair types")
    MError (llp2, msg) -> MError (llp2, msg)

-- Pattern matching
mytypecheck  env (EMatchL p e1 n1 (x1, x2, e2)) =
  case (mytypecheck  env e1) of
    MOk (TList a1) -> case (mytypecheck  env n1) of
                          MOk (a2) -> case (mytypecheck  ((x1,a1):(x2,TList a1):env) e2) of
                                      MOk (a3) -> case (a3 == a2) of
                                              True -> MOk (a2)
                                              False -> MError (p, "Mismatched internal types")
                                      MError (llp2, msg) -> MError (llp2, msg)
                          MError (llp, msg) -> MError (llp, msg)
    MOk (_) -> MError (p, "TypeError: Illegal operation for non-list types")
    MError (llp, msg) -> MError (llp, msg)


-- Function application
mytypecheck  env (EApp p e1 e2) =
  case (mytypecheck  env e1) of
    MOk (TArrow a1 a2) -> case (mytypecheck  env e2) of
                        MOk (a3) -> case (a3 == a1) of
                                    True -> MOk (a2)
                                    False -> MError(p, "Mismatched internal types")
                        MError (llp, msg) -> MError (llp, msg)
    MOk (_) -> MError(p, "TypeError: Illegal operation for non-function types")
    MError (llp, msg) -> MError (llp, msg)


-- Lambda expression
mytypecheck  env (EFn p x t1 e1) =
  case (mytypecheck  ((x,t1):env) e1) of
    MOk (t2) -> MOk (TArrow t1 t2)
    MError (llp, msg) -> MError (llp, msg)


---------------------------------------------------------------------------------------
------------------------------------EVALUATOR------------------------------------------
---------------------------------------------------------------------------------------

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval fe env program = to_eval_result_type (myeval ((to_new_environment env) ++ (eval_func_to_env fe fe)) program)

-- change function definitions into environment shape
eval_func_to_env:: [FunctionDef p] -> [FunctionDef p] -> [(Var,MyValue p)]
eval_func_to_env fe [] = []
eval_func_to_env fe (x:xs) = ((funcName x), (CF (fe, (funcArg x, funcBody x)))):(eval_func_to_env fe xs)

-- change environment type into internal env type
to_new_environment:: [(Var,Integer)] -> [(Var, MyValue p)]
to_new_environment [] = []
to_new_environment ((x,n):xs) = (x, N n):to_new_environment xs

-- convert internal Value type into a Result Type
to_eval_result_type:: Maybe (MyValue p)-> EvalResult
to_eval_result_type result =
  case result of
    Just (N n) -> Value n
    Nothing -> RuntimeError

---------------------------------------------------------------------------------------
----------------------Data Types Definitions-------------------------------------------
---------------------------------------------------------------------------------------
data MyValue p =
 N Integer
 | TF Bool
 | L [MyValue p]
 | P (MyValue p, MyValue p)
 | U
 | CF ([FunctionDef p], (Var, Expr p))
 | CL ([(Var, MyValue p)], (Var, Expr p))
  deriving (Show)

---------------------------------------------------------------------------------------
----------------------Internal main function for evaluation----------------------------
---------------------------------------------------------------------------------------

myeval :: [(Var, MyValue p)] -> Expr p -> Maybe (MyValue p)

---------------------------------------------------------------------------------------
----------------------Const------------------------------------------------------------
---------------------------------------------------------------------------------------
-- I. Integer Const
myeval env (ENum p n) =
   Just (N n)

-- II. Boolean Const
myeval  env (EBool p b)
    | b == True = Just (TF True)
    | b == False = Just (TF False)
    | otherwise = Nothing

-- III. Unit Const
myeval  env (EUnit p) = Just (U)

---------------------------------------------------------------------------------------
----------------------Variables--------------------------------------------------------
---------------------------------------------------------------------------------------

myeval  env (EVar p x) =
  case lookup x env of
       Just (n) -> Just (n)
       Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Arithmetic-------------------------------------
---------------------------------------------------------------------------------------
-- I. Add
myeval  env (EBinary p BAdd e1 e2) =
   case (myeval  env e1) of
      Just (N n1) -> case (myeval  env e2) of
                      Just (N n2) -> Just (N (n1 + n2))
                      Nothing -> Nothing
      Nothing -> Nothing

-- II. Sub
myeval  env (EBinary p BSub e1 e2) =
  case (myeval  env e1) of
     Just (N n1) -> case (myeval  env e2) of
                     Just (N n2) -> Just (N (n1 - n2))
                     Nothing -> Nothing
     Nothing -> Nothing


-- III. Mult
myeval  env (EBinary p BMul e1 e2) =
  case (myeval  env e1) of
     Just (N n1) -> case (myeval  env e2) of
                     Just (N n2) -> Just (N (n1 * n2))
                     Nothing -> Nothing
     Nothing -> Nothing

-- IV. Div
myeval  env (EBinary p BDiv e1 e2) =
    case (myeval  env e1) of
      Just (N n1) -> case (myeval  env e2) of
                      Just (N 0) -> Nothing
                      Just (N n2) -> Just (N (n1 `div` n2))
                      Nothing -> Nothing
      Nothing -> Nothing

--V. Mod
myeval  env (EBinary p BMod e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N 0) -> Nothing
                    Just (N n2) -> Just (N (n1 `mod` n2))
                    Nothing -> Nothing
    Nothing -> Nothing

--VI. Minus
myeval  env (EUnary p UNeg e1) =
    case (myeval  env e1) of
      Just (N n1) -> Just (N (-n1))
      Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Boolean----------------------------------------
---------------------------------------------------------------------------------------

-- I. And
myeval  env (EBinary p BAnd e1 e2) =
    case (myeval  env e1) of
      Just (TF b1) -> case (myeval  env e2) of
                        Just (TF b2) -> Just (TF (b1 && b2))
                        Nothing -> Nothing
      Nothing -> Nothing

-- II. Or
myeval  env (EBinary p BOr e1 e2) =
  case (myeval  env e1) of
    Just (TF b1) -> case (myeval  env e2) of
                      Just (TF b2) -> Just (TF (b1 || b2))
                      Nothing -> Nothing
    Nothing -> Nothing

-- III. Not
myeval  env (EUnary p UNot e1) =
    case (myeval  env e1) of
      Just (TF b1) -> Just (TF (not (b1)))
      Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------Binary/Unary Op - Comparision------------------------------------
---------------------------------------------------------------------------------------

-- I. Equal
myeval  env (EBinary p BEq e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 == n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- II. Greather than
myeval  env (EBinary p BGt e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 > n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- II. Less than
myeval  env (EBinary p BLt e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 < n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- III. Greater equal
myeval  env (EBinary p BGe e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 >= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- IV. Less equal
myeval  env (EBinary p BLe e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 <= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

-- V. Not equal
myeval  env (EBinary p BNeq e1 e2) =
  case (myeval  env e1) of
    Just (N n1) -> case (myeval  env e2) of
                    Just (N n2) -> Just (TF (n1 /= n2))
                    Nothing -> Nothing
    Nothing -> Nothing

---------------------------------------------------------------------------------------
----------------------If/Else and Let expression evaluation----------------------------
---------------------------------------------------------------------------------------

-- I. if____then____else
myeval  env (EIf p e1 e2 e3) =
  case (myeval  env e1) of
    Just (TF True) -> myeval  env e2
    Just (TF False) -> myeval  env e3
    Nothing -> Nothing

-- II. let_____in______
myeval  env (ELet p x e1 e2) =
  case (myeval  env e1) of
    Just (n) -> myeval  ((x, n):env) e2
    Nothing -> Nothing

----------------------------------------------------------------------------------------
-------------------List/Pair/Lambda/Function expresssions evaluation--------------------
----------------------------------------------------------------------------------------

-- lambda closure
myeval env (EFn p x t1 e) = Just (CL (env, (x, e)))

-- function/lambda application
myeval env (EApp p e1 e2) =
  case (myeval env e1) of
    Just (CL (env2, (x1, e3)) ) -> case (myeval env e2) of
                                 Just (v) -> case (myeval ((x1, v):env2) e3) of
                                                Just (v2) -> Just (v2)
                                                Nothing -> Nothing
                                 Nothing -> Nothing
    Just (CF (env3, (x1, e3) )) -> case (myeval env e2) of
                                Just (v) -> case (myeval ((x1, v):(eval_func_to_env env3 env3)) e3 ) of
                                                Just (v2) -> Just (v2)
                                                Nothing -> Nothing
                                Nothing -> Nothing
    Nothing -> Nothing

-- II. Non-empty list
myeval  env (ECons p e1 e2) =
  case (myeval  env e1) of
    Just (v0) -> case (myeval  env e2) of
                  Just (v1) -> Just (L (v0:[v1]))
                  Nothing -> Nothing
    Nothing -> Nothing

-- III. Empty list
myeval  env (ENil p t) =
  case (t) of
    (TList t2) -> Just (L ([]))
    _ -> Nothing

-- IV. Pair
myeval  env (EPair p e1 e2) =
  case (myeval  env e1) of
    Just (v1) -> case (myeval  env e2) of
                  Just (v2) -> Just (P (v1,v2))
                  Nothing -> Nothing
    Nothing -> Nothing

-- V. fst Pair
myeval  env (EFst p e1) =
  case (myeval  env e1) of
    Just (P (v1,v2)) -> Just (v1)
    Nothing -> Nothing

-- VI. snd Pair
myeval  env (ESnd p e1) =
  case (myeval  env e1) of
    Just (P (v1,v2)) -> Just (v2)
    Nothing -> Nothing

-- VII. Pattern Matching
myeval  env (EMatchL p e1 n1 (x1, x2, e2)) =
  case (myeval  env e1) of
    Just (L ([])) -> case (myeval  env n1) of
                      Just (v) -> Just (v)
                      Nothing -> Nothing
    Just (L (v0:[v1])) -> case (myeval  ((x1,v0):(x2,v1):env) e2) of
                            Just (v3) -> Just (v3)
                            Nothing -> Nothing
    Nothing -> Nothing
