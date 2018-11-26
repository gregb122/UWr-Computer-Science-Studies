{-# LANGUAGE Safe #-}
module Compiler_v1(compile) where
import AST
import MacroAsm
import Control.Monad.State

-----------------Programming Methods Course 2017-------------------
-----------------Author: Adam Kufel--------------------------------
-----------------Computer Science Studies, 1st Year----------------
-----------------Wroclaw University 2017---------------------------
-----------------Haskell/GHCi--------------------------------------
--------Compiler for simple programming language, which includes:--
---1.if else construct
---2.let construct
---3.int and bool arithmetic (+,-,*,div,mod,and,or,not)
---4.comparision operations (<,>,<=,>=,<>,==)

--------------------ADDITIONAL FUNCIONS-----------------------------
--create stack image(list of pairs, where in each element on 1st place is name of variable, on 2nd place is current position on stack)
from_vars_to_stack:: [Var]-> Int -> [(Var, Int)]
from_vars_to_stack [] _ = []
from_vars_to_stack (x:xs) n = (x,n):(from_vars_to_stack xs (n+1))

--change position of vars in stack
movepos:: [(Var, Int)] -> [(Var, Int)]
movepos = map (\(x, b) -> (x, b + 1))

--generate fresh labels for jump instructions. To ensure labels will not repeatable, state monad was used.
freshlabel:: St Label
freshlabel = do
  x <- get
  put (x+1)
  return x

--match to the final format
to_final_format:: St [MInstr] -> [MInstr]
to_final_format code = fst $ runState code 0

----------------------MAIN FUNCTIONS--------------------------------
compile :: [FunctionDef p] -> [Var] -> Expr p -> [MInstr]
compile fe vars program = to_final_format $ mycompile (from_vars_to_stack vars 0) program

--internal function for compiling
mycompile:: [(Var, Int)] -> Expr p -> St [MInstr]
type St = State Label

-- Int values
mycompile env (ENum p e1) = return [MConst e1]

-- Boolean values are repesented by :-1 = True 0 = False
mycompile env (EBool p e1) =
  case e1 of
    True -> return [MConst (-1)]
    False -> return [MConst 0]

-- Variable
mycompile env (EVar p x) =
  case (lookup x env) of
     Just n -> return [MGetLocal n]

-- Unary op
mycompile env (EUnary p un_op e1) =
  case un_op of
    UNeg -> do
            l1 <- mycompile env e1
            return (l1 ++ [MNeg])
    UNot -> do
            l1 <- mycompile env e1
            return (l1 ++ [MNot])

-- Binary op
mycompile env (EBinary p bin_op e1 e2) =
  case bin_op of
    BAdd ->  do
             l1 <- mycompile env e1
             l2 <- mycompile (movepos env) e2
             return (l1 ++ [MPush] ++ l2 ++ [MAdd])
    BSub -> do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MSub])
    BMul -> do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MMul])
    BDiv -> do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MDiv])
    BMod -> do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MMod])
    BAnd -> do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MAnd])
    BOr ->  do
            l1 <- mycompile env e1
            l2 <- mycompile (movepos env) e2
            return (l1 ++ [MPush] ++ l2 ++ [MOr])
    BGt ->  do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_GT l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])
    BLt ->  do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_LT l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])
    BLe ->  do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_LE l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])
    BGe ->  do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_GE l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])
    BEq ->  do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_EQ l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])
    BNeq -> do
            l1 <- freshlabel
            l2 <- freshlabel
            r1 <- mycompile env e1
            r2 <- mycompile (movepos env) e2
            return (r1 ++ [MPush] ++ r2 ++ [MBranch MC_NE l1] ++ [MConst 0] ++ [MJump l2] ++ [MLabel l1] ++ [MConst (-1)] ++ [MLabel l2])

-- if else then
mycompile env (EIf p e1 e2 e3) = do
  l1 <- freshlabel
  l2 <- freshlabel
  r1 <- mycompile env e1
  r2 <- mycompile env e2
  r3 <- mycompile env e3
  return (r1 ++ [MBranch MC_Z l1] ++ r2 ++ [MJump l2] ++ [MLabel l1] ++ r3 ++ [MLabel l2])

-- let
mycompile env (ELet var p e1 e2) = do
  r1 <- mycompile env e1
  r2 <- mycompile (movepos env) e2
  return (r1 ++ [MPush] ++ r2 ++ [MPopN 1])
