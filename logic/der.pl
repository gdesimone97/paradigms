is_variable(x).
is_variable(y).

is_base_function(cos(X)) :-
    is_variable(X).
is_base_function(sin(X)) :-
    is_variable(X).
is_base_function(tg(X)) :-
    is_variable(X).
is_base_function(ln(X)) :-
    is_variable(X).
is_base_function(X^N) :-
    is_variable(X),
    number(N).

is_base(X) :-
    number(X); is_variable(X); is_base_function(X).
    

my_equal(X, X).

my_not_equal(X, Y):-
	not(my_equal(X, Y)).


der(cos(F), X, -sin(F)*DF) :-
	der(F, X, DF).

der(sin(F), X, cos(F)*DF) :-
	der(F, X, DF).

der(tg(F), X, -1/(cos(F)*cos(F))*DF) :-
	der(F, X, DF).

der(ln(F), X, 1/(F)*DF) :-
	der(F, X, DF).

der(F^N,X,N*F^(N-1)*DF):-
	integer(N),
	der(F, X, DF).

der(C,_,0):-
	number(C).

der(X, X, 1) :-
	is_variable(X).

der(X, Y, 0) :-
	is_variable(X),
	is_variable(Y),
	my_not_equal(X, Y).

der(F+G, X, DF+DG):-
	der(F,X,DF),
	der(G,X,DG).


der(F*G, X, F*DG + DF*G):-
	der(F,X,DF),
	der(G,X,DG).

der(F/G, X, (DF*G-F*DG)/G^2):-
	der(F,X,DF),
	der(G,X,DG).

ders(F, X, R) :-
	der(F, X, R1),
	simplify(R1, R).


% Base case
simplify(X, X) :-
	number(X); is_base(X).

% Addition
simplify(X+Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_add(SX, SY, R).

% Subtraction
simplify(X-Y, R) :-
    simplify(X, SX),
    simplify(Y, SY),
    simplify_sub(SX, SY, R).

% Product
simplify(X*Y, R) :-
	simplify(X, SX),
	simplify(Y, SY),
	simplify_prod(SX, SY, R).

% Division
simplify(X/Y, R) :-
    simplify(X, SX),
	simplify(Y, SY),
    simplify_div(SX, SY, R).

% exp
simplify(X^Y, R) :-
    simplify(X, SX),
	simplify(Y, SY),
    simplify_exp(SX, SY, R).

simplify(X, X).

% Addition cases
simplify_add(0, X, X).
simplify_add(X, 0, X).
simplify_add(X, X, 2*SX) :-
    simplify(X, SX).
simplify_add(C*X, X, N*SX) :-
    number(C),
    N is C + 1,
    simplify(X, SX).
simplify_add(X, C*X, N*SX) :-
    number(C),
    N is C + 1,
    simplify(X, SX).
simplify_add(C1*X, C2*X, N*SX) :-
    number(C1),
    number(C2),
    N is C1 + C2,
    simplify(X, SX).
simplify_add(X, Y, R) :-
    number(X),
    number(Y),
    R is X + Y.
simplify_add(X, Y, X+Y).

simplify_sub(X, X, 0).
simplify_sub(0, X, -X).
simplify_sub(X, 0, X).
simplify_sub(C*X, X, N*SX) :-
    number(C),
    N is C - 1,
    simplify(X, SX).
simplify_sub(X, C*X, N*SX) :-
    number(C),
    N is -C + 1,
    simplify(X, SX).
simplify_sub(C1*X, C2*X, N*SX) :-
    number(C1),
    number(C2),
    N is C1 - C2,
    simplify(X, SX).
simplify_sub(X, Y, R) :-
    number(X),
    number(Y),
    R is X - Y.
simplify_sub(X, Y, X-Y).


% Product cases
simplify_prod(0, _, 0).
simplify_prod(_, 0, 0).
simplify_prod(X, 1, X).
simplify_prod(1, X, X).
simplify_prod(X, Y, R) :-
    number(X),
    number(Y),
    R is X * Y.
simplify_prod(X, Y, X*Y).

% Division cases
simplify_div(0, X, 0) :-
    my_not_equal(X, 0).
simplify_div(X, 1, X).
simplify_div(X, X, 1).
simplify_div(X, Y, R) :-
    my_not_equal(Y, 0),
    number(X),
    number(Y),
    R is X / Y.
simplify_div(X, Y, X/Y).

% Exp cases
simplify_exp(_, 0, 1).
simplify_exp(X, 1, X).
simplify_exp(X, Y, R) :-
    number(X),
    number(Y),
    R is X ^ Y.
simplify_exp(X, Y, X^Y).

