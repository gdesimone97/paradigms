%! create(+DimTuple)
%
% The create/1 predicate succeeds if the DimTuple contains valid chessboard 
% dimensions, e.g. (0,0) or (2,4).
create((DimX, DimY)) :-
	DimX < 9,
    DimY < 9,
    DimX > -1,
    DimY > -1;
    fail.

%! attack(+FromTuple, +ToTuple)
%
% The attack/2 predicate succeeds if a queen positioned on ToTuple is 
% vulnerable to an attack by another queen positioned on FromTuple.
attack((FromX, FromY), (ToX, ToY)):-
    X is ToX - FromX,
    Y is ToY - FromY,
    X =:= Y.

attack((FromX, FromY), (ToX, ToY)):-
    X is ToX - FromX,
    Y is ToY - FromY,
    X =:= -Y.

attack((FromX, FromY), (ToX, ToY)):-
    FromX =:= ToX.

attack((FromX, FromY), (ToX, ToY)):-
    FromY =:= ToY.
