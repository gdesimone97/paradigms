%%Primitive derivate
der(sin(X),X,cos(X)).
der(cos(X),X,-sin(X)).
der(tan(X),X,1/cos(X)*cos(X)).

der(-F, X, -DF):-
    der(F, X, DF).

der(C,X,0):-
    C \= X,
    atomic(C),
    atomic(X).

der(X^1,X,1).
der(X,X,1) :- der(X^1,X, 1). %alias
der(X^C, X, DF):-
    number(C),
    DIFF is C -1,
    DF = C * X^[DIFF];
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
der(F+G, X, R):-
    der(F, X, DF),
    der(G, X, DG),
    simp(DF+DG, R).

%Div
der(F/G, X, [DF*G-F*DG]/[G^2]):-
    der(F, X, DF),
    der(G, X, DG).

%Mult
der(F*G, X, R):-
    der(F, X, DF),
    der(G, X, DG),
    simp(DF*G+DG*F, R).

der_eval(F, X, V, R):-
    number(V),
    der(F, X, DF),
    X is V,
    evaluate(DF, R).

%Utils
evaluate(A,R):-
    R is A.

simp(X+X, 2*X).
simp(0*X, 0).
simp(X*0, 0).
simp(-(-X), X).
simp(+(-X), -X).
simp(X*1, X).
simp(1*X, X).
simp(X^1, X).
simp(X^0, 1).
simp(X+0, X).
simp(0+X, X).
simp(X+Y, RS):-
    number(X),
    number(Y),
    RS is X + Y ;
    simp(X, RX),
    simp(Y, RY),
    R=RX+RY,
    simp(R, RS);
    RX=X,
    simp(Y, RY),
    R=RX+RY,
    simp(R, RS);
    simp(X, RX),
    RY=Y,
    R=RX+RY,
    simp(R, RS);
    RS = X + Y.
simp(X*Y, RS):-
    number(X),
    number(Y),
    R is X * Y,
    simp(R, RS);
    number(X),
    simp(Y, RY),
    R = X * RY,
    simp(R, RS);
    number(Y),
    simp(X, RX),
    R  = RX * Y,
    simp(R, RS).