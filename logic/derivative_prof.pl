is_variable(x).
is_variable(y).

my_equal(X, X).
my_not_equal(X, Y):-
    not(my_equal(X, Y)).

der(cos(F), G, -sin(F) * DF):-
    der(F, X, DF).

der(sin(F), G, cos(F) * DF):-
    der(F, X, DF).

%%Primitive derivate
der(sin(X),X,cos(X)).
der(cos(X),X,-sin(X)).
der(log(X), X, 1/x).
der(tan(X),X,1/cos(X)*cos(X)).

der(-F, X, -DF):-
    der(F, X, DF).

der(C,X,0):-
    number(C).

der(X,Y,0):-
    is_variable(X),
    is_variable(Y),
    my_not_equal(X, Y).

der(X^1,X,1).
der(X,X,1) :- der(X^1,X, 1). %alias
der(X^C, X, DF):-
    number(C),
    DIFF is C -1,
    DF = C * X^DIFF;
    nonvar(C),
    DF = C * X^[C-1].

der(C*X, X, C*DF):-
    atomic(C),
    der(X, X, DF).

der(X^C, Y, 0):-
    X \= Y,
    atomic(C),
    atomic(Y),
    atomic(X).

%%Operations
%Sum
der(F+G, X, DF+DG):-
    der(F, X, DF),
    der(G, X, DG).

%Div
der(F/G, X, [DF*G-F*DG]/[G^2]):-
    der(F, X, DF),
    der(G, X, DG).

%Mult
der(F*G, X, DF*G+DG*F):-
    der(F, X, DF),
    der(G, X, DG).

der_eval(F, X, V, R):-
    number(V),
    der(F, X, DF),
    X is V,
    evaluate(DF, R).

%%Utils
evaluate(A,R):-
    R is A.

%Simp derivate
ders(F, X, R):-
    der(F, X, R1),
    simp(R1, R).

simp(X+X, 2*X).
simp(0*X, 0).
simp(X*0, 0).
simp(-(-X), X).
simp(+(-X), -X).
simp(X*1, RX):-
    simp(X, RX).
simp(1*X, X).
simp(X^1, X).
simp(X^0, 1).
simp(X+0, X).
simp(0+X, X).
simp(X+Y, R):-
    simp(X, RX),
    simp(Y, RY),
    simp(RX+RY, R).
simp(X*Y, R):-
    simp(X, RX),
    simp(Y, RY),
    simp(RX*RY, R).
simp(X, X):-
    number(X).