use_module(library(lists)).

parse(A,B,R1,R2):-
    atom(A),
    atom(B),
    R1 = A,
    R2 = B;
    compound(A),
    compound(B),
    exp(A,R1),
    exp(B,R2);
    atom(A),
    compound(B),
    R1 = A,
    exp(B,R2);
    compound(A),
    atom(B),
    exp(A,R1),
    R2 = B.

parse(A,R):-
    atom(A),
    R = A;
    compound(A),
    exp(A,R).

or(A,B,R):-
    parse(A,B,R1,R2),
    RT = R1+R2,
    simp(RT,R).

and(A,B, R):-
    parse(A,B,R1,R2),
    RT = R1*R2,
    simp(RT,R).

not(A, -R):-
    parse(A,RN),
    RT = -RN,
    simp(RT,R).

exp(E,R):-
     compound_name_arguments(E, F, A),
    (   same_term(F, or) ->
        nth0(0,A,A1),
        nth0(1,A,A2),
        or(A1,A2,R);
        same_term(F,and)->
        nth0(0,A,A1),
        nth0(1,A,A2),
        and(A1,A2,R);
        same_term(F,not)->
        nth0(0,A,A1),
        not(A1,R);
        fail
    ).

distr(E1*(E2+E3), E1*E2+E1*E3).
demorgan(-(E1+E2), -E1*(-E2)).
demorgan(-(E1*E2), -E1+(-E2)).
doub(-(-E1), E1).

simp(E,R):-
       (distr(E,RT);
        demorgan(E,RT);
        doub(E,RT)   ),
        simp(RT,R);
        R = E.
