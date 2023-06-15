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
der(X,X,1) :- der(X**1,X,1). %alias
der(X**C, X, C * X**[C-1]).

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