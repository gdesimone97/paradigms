%Definizone di lista in prolog
%list([]).
%list([X|Xs]).
%list([a,b,c]).

%prefix([], Ys).
%prefix([X|Xs],[X|Ys]).

%Esiste una libreria in prolog chiamata:
use_module(library(lists)).

adjacent(X,Y,Zs):-
    append(As,[X,Y|Ys],Zs).

last(X, Xs):-
    append(As, [X], Xs).

sublist(Xs,Ys):-
    append(As, XsBs, AsXsBs),
    append(Xs,Bs,XsBs).




