:- module(sat, [solve/2]).
:- op(200, fx, ~).
:- op(500, xfy, v).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UWR Computer Science - Programming Methods Course 2016/2017 %
% Project nr 1 - Solution for 2SAT Problem                    %
% Author: Adam Kufel                                          %
% 2017 Wroclaw                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%___PART_ONE___%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----- Change a set of clauses into a list of variables.-----%

%IN/OUT EXAMPLE
%changeset([p v ~q, r v ~s, t, ~t,~p, []],X).
%X = [q, r, s, t, p, []]


%Split single clause by "v" op into a list of literals.
remove_v_op(Literal1 v Literal2, [Literal1|RestofLiterals]) :-
    remove_v_op(Literal2,RestofLiterals),!.
remove_v_op(Literal,[Literal]).


%Remove "~" op from elements of list of literals.
remove_neg([Literal|RestofLiterals], [Var|RestofVars]) :-
    Literal = ~Var, remove_neg(RestofLiterals, RestofVars), !.
remove_neg([Literal|RestofLiterals], [Literal|RestofVars]) :-
    remove_neg(RestofLiterals, RestofVars).
remove_neg([],[]) :- !.


%Remove duplicates of variables in list.
remove_dups([], []) :- !.
remove_dups([Var|RestofVars],[Var|RestNoDups]) :- not(member(Var, RestofVars)),remove_dups(RestofVars, RestNoDups).
remove_dups([Var|RestofVars],RestNoDups) :- member(Var, RestofVars), remove_dups(RestofVars, RestNoDups).


%Transform single clause into the list of variables.
changeclause(Clause, ListofVars) :-
    remove_v_op(Clause, Tmpres1), remove_neg(Tmpres1, Tmpres2), remove_dups(Tmpres2, ListofVars), !.


%Transform set of clauses into the list of variables.
changeset([], []) :- !.
changeset([Clause|RestofClauses], ListofVars) :-
    changeclause(Clause, Vars), changeset(RestofClauses, RestofVars2), append(Vars, RestofVars2, Result), remove_dups(Result, ListofVars), !.


%%%%%%%%%%%%%%%%%%%%%___PART_TWO___%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----- Generate all permutations of boolean values for a list of
% variables.-----%
%
% t - true
% f - false
%
%IN/OUT EXAMPLE
% valgen([p,q], Y).
% Y = [(p, t), (q, t)]
% Y = [(p, t), (q, f)]
% Y = [(p, f), (q, t)]
% Y = [(p, f), (q, f)]


valgen([], []).
valgen([Var|RestofVars],[(Var, t)|RestofPerm]) :-
    valgen(RestofVars, RestofPerm).
valgen([Var|RestofVars],[(Var, f)|RestofPerm]) :-
    valgen(RestofVars, RestofPerm).


%%%%%%%%%%%%%%%%%%%%%___PART_THREE___%%%%%%%%%%%%%%%%%%%%%%%%%


% -----Match all generated values with set of clauses------ %


%IN/OUT EXAMPLE
%solve([p v q, ~p, q v r], X).
%X = [(p, f), (q, t), (r, t)]
%X = [(p, f), (q, t), (r, f)]


checkclause(X, Val) :- member((X, t), Val),!.
checkclause(X, Val) :- member((X, f), Val), false.
checkclause(~X, Val) :- member((X, t), Val), false.
checkclause(~X, Val) :- member((X, f), Val),!.
checkclause(X v Y, Val) :-
   member((X, f), Val), fail ;checkclause(Y, Val), !.
checkclause(X v Y, Val) :-
   member((X, t), Val), !; checkclause(Y, Val), !.
checkclause(~X v Y, Val) :-
   member((X, f), Val), ! ;checkclause(Y, Val), !.
checkclause(~X v Y, Val) :-
   member((X, t), Val),fail ;checkclause(Y, Val), !.


checkset([], _).
checkset([Clause|Restofclauses], Value) :-
         checkclause(Clause, Value), checkset(Restofclauses, Value).


solve(Setofclauses, Solution) :-
    not(member([],Setofclauses)),
    changeset(Setofclauses, Listofliterals),
    valgen(Listofliterals, Value),
    checkset(Setofclauses, Value),
    Value = Solution.


























