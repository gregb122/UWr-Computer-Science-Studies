:- module(adam_kufel_tests, [resolve_tests/5, prove_tests/4]).

% definiujemy operatory ~/1 oraz v/2
:- op(200, fx, ~).
:- op(500, xfy, v).
%testy dla predykatu resolve: zgodnie z poleceniem zadania zalozylem, ze
% pozytywne wystapienia zmiennej sa w 1 klauzuli, negatywne w drugiej)

resolve_tests(przypadekbazowy1, p, p, ~p, []).
resolve_tests(odpowiednikmodusponens, p, p, ~p v q, q).
resolve_tests(przypadekbazowy2, p, p v ~p, ~p v p, ~p v p).
resolve_tests(przypadekpodstawowy, q, q v p, ~q v ~p, p v ~p).
resolve_tests(prostarezolwenta1, q, p v q, p v ~q, p).
resolve_tests(prostarezolwenta2, r, p v ~q v r, p v s v ~r, p v ~q v s).
resolve_tests(prostarezolwenta3, p, p v q v ~r v s, s v q v ~p, q v ~r v s).
resolve_tests(prostarezolwenta4, q, ~r v p v s v q, ~q v r v p v ~s, ~r v p v s v r v ~s).
resolve_tests(prostarezolwenta5, q, q, p v r v s v ~q v t, p v r v s v t).
resolve_tests(prostarezolwenta6, p, ~p v p v r v s, p v ~p v q v t, ~p v r v s v p v q v t).
resolve_tests(rezolwentazdwochklauzulzawierajacychwiecejwystapienzmiennejvar, r, r v r v p v q, ~r v ~r v p v r, p v q v r).
resolve_tests(rezolwentadwochdluzszychklauzul, p, p v p v ~q v r v s v t v a v b v c, ~q v ~p v r v ~p v s v t v ~u, ~q v r v s v t v a v b v c v ~u).
resolve_tests(rezolwentadluzszychklauzul, q, q v p v r v t v q v a v b v c v d v e, p v a v g v d v ~q v ~r v ~q v a v c v d, p v r v t v a v b v c v d v e v g v ~r).
resolve_tests(rezolwentadwochdlugichklauzul, q, p v q v r v a v b v c v d v e v f v g v h v i v j v k v l v m v q, p v ~q v r v a v b v c v d v ~q v k v l v m v i v j, p v r v a v b v c v d v e v f v g v h v i v j v k v l v m).

prove_tests(pojedyncza_zmienna, validity, [p], sat).
prove_tests(pojedyncza_zanegowanazmienna, validity, [~p], sat).
prove_tests(pojedynczaklauzula, validity, [p v p v ~p v q], sat).
prove_tests(zbiorzawierajacypustaklauzule, validity, [[]], unsat).
prove_tests(prosty_zbior_klauzul, validity, [p v q, ~p, r v ~q, q], sat).
prove_tests(prostydowod_sprzecznyzbior, validity, [p v ~q, q v ~r, r, ~p], unsat).
prove_tests(zbior_sprzecznychklauzul, validity, [p v q v ~r, r, ~p v ~q v ~r], sat).
prove_tests(zbiorwieluklauzulsprzeczny,validity,[p, p v q, p v ~q, r, q v r, r v ~p, r v ~q, ~q v r v s, s v r, p v s, s v ~p, ~q, ~s v ~p v q], unsat).
prove_tests(zbiorklauzulzwielomazmiennymisprzeczny, validity,[p v q, z v s, t, e, r v ~t, y, u v i, p v g, ~e v t, ~z v d, c v d, []], unsat).
prove_tests(dodatkowy_test, validity, [a v b v c, ~a v b v c, a v ~b v c, a v b v ~c], sat).
prove_tests(zbior_klauzul,validity, [p v q v r, ~p v q, ~r, q v r, ~q], unsat).
prove_tests(duzyzbiorklauzul, validity, [p v q v r v s v t, ~p v ~q v r, ~s, t v ~q, ~p v ~r, s v r, p v q, ~t v p], unsat).
prove_tests(zbior_z_klauzula_z_20_zmiennymi_i_ich_pojedynczymi_klauzulami_i_klauzula_pusta, performance, [a v b v c v d v e v f v g v h v i v j v k v l v m v n v o, ~a, ~b, ~c, ~d, ~e, ~f, ~g, ~h, ~i, ~j, []], unsat).
prove_tests(zbior_dlugichklauzulzklauzulapusta, performance, [p v q v r v s v t v a v b v c, ~p v q v r v ~s v t v ~u, a v b v c v d v e v g v j v i, y v t v r v u v a v ~c v ~b, [], p v ~q], unsat).
prove_tests(zbior_dlugich_klauzul, performance,[a v ~b v c v ~d v e v ~f v g v ~h v i v ~j v k v ~l v m v ~n v o, b, d, f, h, j, l, n, a v ~c, e v ~g, i v ~k, m v ~o, ~a v c, ~e v g, ~i v k, ~m v o], sat).












