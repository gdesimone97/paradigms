%triangle(Side1, Side2, Side3, Type).

check(A,B,C):-
    A > 0,
    B > 0,
    C > 0,
    T1 is A + B,
    T1 >= C,
    T2 is B + C,
    T2 >= A,
    T3 is A + C,
    T3 >= B.

triangle(A,B,C, "equilateral"):-
    check(A,B,C),
    A =:= B,
    B =:= C,
    A =:= C.

triangle(A,B,C,"isosceles"):-
    triangle(A,B,C, "equilateral").

triangle(A,B,C,"isosceles"):-
    check(A,B,C),
    (A =:= B,
	C =\= A;
    B =:= C,
	A =\= B;
    A =:= C,
	B =\= A).

triangle(A,B,C,"scalene"):-
    check(A,B,C),
    A =\= B,
    B =\= C,
    A =\= C.

