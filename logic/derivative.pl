%Primitive func
sub(A,B,R) :-
    R is A - B.

%%Primitive derivate
der(sin(X),X,cos(X)).
der(cos(X),X,-sin(X)).
der(tan(X),X,1/cos(X)*cos(X)).

%Constant
der(C,X,0):-
    atomic(C),
    atomic(X).

%Power
der(X^1,X,1).
der(X,X,1) :- der(X^1,X,1). %alias
der(X^C, X, DF):-
    number(C),
    DIFF is C -1,
    DF = C * X^[DIFF];
    nonvar(C),
    DF = C * X^[C-1].

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

%Utils
evaluate(A,R):-
    R is A.