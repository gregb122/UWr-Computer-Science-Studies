{-# LANGUAGE Safe #-}
module Interpreter_Tests(tests) where
import DataTypes
-----------------Programming Methods Course 2017-------------------
-----------------Author: Adam Kufel--------------------------------
-----------------Computer Science Studies, 1st Year----------------
-----------------Wroclaw University 2017---------------------------
-----------------Haskell/GHCi--------------------------------------
-----------------Tests for Interpreter_v3:-------------------------
-------------------------------------------------------------------
---Tested features:
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

tests :: [Test]
tests =
  -- Tests for Interpreter_v1
  [ Test "inc"      (SrcString "input x in x + 1") (Eval [42] (Value 43))
  , Test "undefVar" (SrcString "x")                TypeError
  , Test "undefVar2" (SrcString "20 + 7 - (2 * 30 mod x)") TypeError
  , Test "constant" (SrcString "input x y in 8") (Eval [3,4] (Value 8))
  , Test "novars1" (SrcString "2 + 2 * 2") (Eval [] (Value 6))
  , Test "novars2" (SrcString "(-18) * 4 - 4 div (13 - 5 mod 2 * 10 - (50 * 5))") (Eval [] (Value (-71)))
  , Test "wrongTypeoperation1" (SrcString "input x in x + true") TypeError
  , Test "wrongTypeoperation2" (SrcString "input x y in x and y") TypeError
  , Test "wrongTypeoperation3" (SrcString "input z t in z + t and 5") TypeError
  , Test "wrongTypeoperation4" (SrcString "input z in 8 <= true") TypeError
  , Test "wrongTypeoperation5" (SrcString "input z y x in x = true") TypeError
  , Test "wrongTypeoperation6" (SrcString "input x y in let x = y < 7 in y = 10 * x") TypeError
  , Test "wrongTypeoperation7" (SrcString "input x y z in if x >= y then let x = y < 6 in if x then x + 8 else y else x * y + z") TypeError
  , Test "undefinedvar2" (SrcString "input x in x div y") TypeError
  , Test "simplearithmetic1" (SrcString "input x y in x * y") (Eval [3,5] (Value 15))
  , Test "simplearithmetic2withbool" (SrcString "input x in if x < 10 then x else x div 2") (Eval [20] (Value 10))
  , Test "simplearithmetic3" (SrcString "input x y in y - x") (Eval [10,20] (Value 10))
  , Test "simplearithmetic4" (SrcString "input y x in x mod y") (Eval [9,13] (Value 4))
  , Test "simpleletoperation1" (SrcString "input x in let x = 7 in x * 2") (Eval [30] (Value 14))
  , Test "simpleletoperation2" (SrcString "input x z in let x = 12 in x div z") (Eval [2,4] (Value 3))
  , Test "simpleletoperation3" (SrcString "input x y z in if x >= y then y + z else let x = 3 in x * y + 4") (Eval [3,5,2] (Value 19))
  , Test "letop1" (SrcString "input x y in let x = y < 6 in if x then y * 4 else y") (Eval [2,4] (Value 16))
  , Test "letexp2" (SrcString "input x y z in if x < y then let x = z < 8 in if x then z else y else x * 100") (Eval [1,2,3] (Value 3))
  , Test "divbyzero0" (SrcString "input x y in x div y") (Eval [2,0] (RuntimeError))
  , Test "modzero" (SrcString "input x in x mod 0") (Eval [10] (RuntimeError))
  , Test "divbyzero1" (SrcString "input x y in x * (100 - (y div x))") (Eval [0,100] (RuntimeError))
  , Test "simplebool3" (SrcString "input x y in if x <> y and x < 10 then let y = x in y * (x mod 5) else y + x") (Eval [9,11] (Value 36))
  , Test "arithmetic1" (SrcString "input x y z u w in x * (2 + y - (x mod u) + w div (2 - 15 * (x - 7)))") (Eval [1,2,3,2,1] (Value 3))
  , Test "arithmetic2" (SrcString "input x y z in x mod (y * y + z * (10 + x))") (Eval [6,9,4] (Value 6))
  , Test "bignumbers1" (SrcString "input x y in x + y") (Eval [4023872600770937735437024339230039857193748642107146325437999104299385123986290205920442084869694048004799886101971960586316668729948085589013238296699445909974245040870737599188236277271887325197795059509952761208749754624970436014182780946464962910563938874378864873371191810458257836478499770124766328898359557354325131853239584630755574066882029120737914385371958824980812686783837455973174613608532,955131156552036093988180612138558600301435694527224206344631797460594682573103790084024432438465657245014402821885252470935190620929023136493273497565513958720559654228749774011413346962715422845862377387538230483865688976461927383814900140767310446640259899490222221765904339901886018566526485061799702356193897017860040811889729918311021171229845901641921068884387121855646124960798722908519296815319266498753372]
 (Value 955131156556059966588951549873995624640665734384417954986738943786032681677403175208010722644386099329884096869890052357037162581515339805223221583154527197017259100138724019052284084561903659123134264712736025543375641737670677138439870576781493227586724862400786160640283204775257210376984742898278202126318663346758400369244055050164260755860601475708803098005125036241018083785779535595303134271292441112361904))
  , Test "bignumbers2" (SrcString "input x y in x * x * x * y * y * y") (Eval [719374864210714632543799910429938512398629020592044208486969404800479988610197196058631666872,6461249607987229085192968153192664987533729551311565560599665889515498739956246406657343844179]
  (Value 100418870800062433203701399334074290182518279681154744302789778487061824983983020175370653530005134141671489479358929558433536546041284268350592109856304328660017005278964166467396615632721218580505082761360091931287033923285803528445973232038986511753917950931836972222386303294598208346640837896859396930080228246645899800231260091256418822473190410385906988519209797405109902661426662257307545191233742597023669449254098717290907944017669174457720084199506746920550758432006056721539645771810643407243675704906162225144433183568806875199210911308605197097472))
  , Test "lots_of_vars1" (SrcString "input q w e r t y u i o p a s d f in q * (w + e) * r * (t - (y + u)) - i + o * p div (a - s) + d * f") (Eval [1,2,3,4,5,6,7,8,9,10,11,12,13,14] (Value (-76)))
  , Test "nestedexpr1" (SrcString "input x y z u in if x < 7 then if y < z then let x = 8 in x + 5 else if u > z then 5 * 10 else x - 5 else y") (Eval [-1,-5,-3,-4] (Value 13))

  -- Tests for Interpreter_v2
  , Test "simpledef1_fib" (SrcString "fun f1(n : int) : int = if n <= 1 then 1 else f1(n-1) + f1(n-2) input x in x * 4 + f1(x)") (Eval [5] (Value 28))
  , Test "simpledef2" (SrcString "fun f2(n : int * int) : int = (fst n) + (snd n) input x y z in z * y div (f2((x,6)) - 5)") (Eval [4,6,5] (Value 6))
  , Test "simpledef3" (SrcString "fun f3(n : int) : bool = n >= 10 input z x in if f3(z) then (-z) else x") (Eval [11,6] (Value (-11)))
  , Test "simpledef6" (SrcString "fun f6(n : int list) : int = match n with [] -> 0 | x :: xs -> f6(xs) + 1 in f6([1,2,5,6]:int list)") (Eval [] (Value 4))
  , Test "simpledef7" (SrcString "fun f7(n : int list) : int = match n with [] -> 0 | m :: ms -> f7(ms) + m input x y z u in if f7([x,y,z,u]:int list) < 20 then x + y else x mod 0") (Eval [4,3,2,1] (Value 7))
  , Test "wrongtype1" (SrcString "fun w1(n : (int list) * (int list)) : int list = (fst n) input x y in 5 + w1((x,y))") TypeError
  , Test "wrongtype2" (SrcString "fun w2(n : int) : int list = if n > 0 then [n]:int list else []:int list input x in 456 + w2(x)") TypeError
  , Test "wrongtype3" (SrcString "fun w3(n : int * int) : bool = if (fst n) > 4 then true else false input x in 17 * w3((6,x))") TypeError
  , Test "wrongtype4" (SrcString "fun w4(n : int * int list) : int = if (fst n) > 4 then 0 else 1 input x in 17 * w4((8,x)) + y") TypeError
  , Test "wrongtype5" (SrcString "fun w5(n : int * int list) : int = if n > 5 then (snd n) else (snd n) input x in 2 * w5((x,[1,2,3]:int list))") TypeError
  , Test "wrongtype7" (SrcString "fun w7(n : int list) : int list = match n with [] -> [0]:int list | x :: xs -> (-x)::w7(xs) input x y in if let x = true in x and false then w7([1,4,x,y]:int list) else w7([1,2,3]:int list)") TypeError
  , Test "wrongtype11" (SrcString "fun w11(n : int * int) : bool = if (fst n) > 4 then true else false fun w11A(n : int) : int = if n = 0 then 10 else 10 + w11A(n-1) input x in x + 10 * w11((3,6)) + w11A(x)") TypeError
  , Test "runtime1" (SrcString "fun r1(n : int) : int = if n > 10 then 0 else 1 input x in r1(x mod 0) + 4 * 123") (Eval [10] (RuntimeError))
  , Test "loop2" (SrcString "fun loop(u : unit) : bool = if loop () then true else false input x y z in loop() + x div (y * (10 mod 0))") TypeError
  , Test "runtimeError1"          (SrcString "0 * (14 div 0)") (Eval [] RuntimeError)
  , Test "runtimeError2"          (SrcString "if (100 div 0 <> 0) then 50 else 25")   (Eval [] RuntimeError)
  , Test "runtimeError3"          (SrcString "let y = 3 div 0 in y ") (Eval [] RuntimeError)
  , Test "divisionSmart"        (SrcString "(1 div 0) + 2") (Eval [] RuntimeError)
  , Test "matchtest" (SrcString " match [(1, true),(2, false)] : (int*bool) list with | [] -> 0 | x :: xs -> fst x") (Eval [] (Value 1))
  , Test "envtest" (SrcString "fun def1(l : bool list) : bool = match l with | [] -> 3 | x :: xs -> def2(xs) and x in if def1([true, false, false] : bool list ) then 7 else 1") TypeError
  , Test "nestedpairs" (SrcString "fun foo(x : int * ((int * (int * bool))* bool)) : int * bool = snd (fst (snd x)) in fst (foo(5,((4 , (7, true)), false)))") (Eval [] (Value 7))
  , Test "unitlooptest" (SrcString "fun loop(u : unit) : int = loop() input x in if x = 1 then loop() + 1 div 0 else  5 div 0 + loop()") (Eval [2] (RuntimeError))
  , Test "fsttest1" (SrcString "input x y in fst (x,y)") (Eval [5,8] (Value 5))
  , Test "sndtest1" (SrcString "input x y in snd (x,y)") (Eval [8,11] (Value 11))

-- Tests for Interpreter_v3
  , Test "lambdaundefVar2" (SrcString "input x in fn(n:int) -> n + y") TypeError
  , Test "wrong_arg_type_lambda" (SrcString "input x in (fn(n:bool) -> if n then 1 else 2) x") TypeError
  , Test "wrongtype1" (SrcString "fun f(x : int): int = x input x in let f = x in f f") TypeError
  , Test "wrongtype2_let" (SrcString "input x in let f = fn(x:int) -> f 1 * 7 in f 6") TypeError
  , Test "wrongtype3_if" (SrcString "fun f4 (x : int) : int = if x >= 0 then true else false input y in f4(y) + 40 - 2") TypeError
  , Test "finalwrongtype_lambda" (SrcString "input x y in fn(x:int) -> x + 5") TypeError
  , Test "wrongnames"        (SrcString "fun f2(x : int): bool = x input y in let f2 = x in f2 f2")      TypeError
  , Test "simplelambda2" (SrcString "input x y in (fn(x:int) -> x - 10) 3") (Eval [5,7] (Value (-7)))
  , Test "simplelambda3" (SrcString "input x y in (fn(n:int) -> n + y - 16) x") (Eval [10,14] (Value 8))
  , Test "simplelambdaruntimeerr" (SrcString "input x y in (fn(n:int) -> n div (x - y)) 10") (Eval [10,10] (RuntimeError))
  , Test "simplelambda_if_5" (SrcString "input x y in (fn(n:bool) -> if n then x else y) (x < 10)") (Eval [8,10] (Value 8))
  , Test "pairlambda6" (SrcString "input x y in (fst (fn(x:int) -> x + 1, fn(x:int) -> x + 2)) y") (Eval [10,15] (Value 16))
  , Test "pairlambda7" (SrcString "input x in let f = fn(x:int) -> x + 2 in snd(f 3, f 5)") (Eval [5] (Value 7))
  , Test "if_lambda1" (SrcString "input x in (if x > 0 then fn(x:int) -> x + 1 else fn(x:int) -> x + 2) x") (Eval [4] (Value 5))
  , Test "if_lambda2" (SrcString "input x y in (if x > 10 then fn(x:int) -> x div (y - 10) else fn(x:int) -> x + 1) y") (Eval [15,10] RuntimeError)
  , Test "lambda_nest1"         (SrcString "input x in (fn(n: int) -> (fn(m: int) ->  n * m)) 5 x")               (Eval [5] (Value (25)))
  , Test "list_lambda1" (SrcString "fun head(n:(int -> int) list): (int -> int) = match n with | [] -> fn(x:int) -> 0 | x :: xs -> x in (head ([(fn(x:int) -> 2 * x), (fn(y:int) -> 3 * y)] : (int -> int) list)) 5") (Eval [5] (Value 10))
  , Test "list_lambda2" (SrcString "fun empty(n:(int -> int) list): (int -> bool) = match n with | [] -> fn(x:int) -> true | x :: xs -> fn(x:int) -> false input x in if (empty ([(fn(x:int) -> x + 1), (fn(x:int) -> x div 0)]: (int -> int) list) 5) then 0 else 1") (Eval [10] (Value 1))
  , Test "lambdainlambda1" (SrcString "(fn(f:int -> int) -> fn(x:int) -> f (f x)) (fn(x:int) -> 2 * x) 3") (Eval [] (Value 12))
  , Test "lettest1" (SrcString "let x = 5 in let f = fn(y:int) -> x + y in let x = 6 in f 1") (Eval [] (Value 6))
  , Test "funtest1" (SrcString "fun twotimes(f:int -> int): (int -> int) = fn(i:int) -> f (f i) in twotimes (fn(x:int) -> x + 2) 3 ") (Eval [] (Value 7))
  , Test "returnLambdaToFunc"(SrcString "fun fakeLambda(f : int -> int) : (int -> int) = fn (x : int) -> x + 5 in (fakeLambda(fn(x : int) -> x) 5)") (Eval [] (Value 10))
  ]
