%not_gate(X,Y).
%and_gate(X,Y,Z).
%or_gate(X,Y,Z).

not_gate(a, r).
and_gate(r, b, s).
or_gate(s, c, t).
not_gate(t, x).

input_signal(a, 0).
input_signal(b, 1).
input_signal(c, 0).

or(0,0,0).
or(1,0,1).
or(0,1,1).
or(1,1,1).

and(0,0,0).
and(1,0,0).
and(0,1,0).
and(1,1,1).

not(0, 1).
not(1, 0).

signal_value(S,V):-
	input_signal(S, V).
	
signal_value(S,V):-
	not_gate(R,S),
	signal_value(R,T),
	not(T,V).

signal_value(S,V):-
	or_gate(A,B,S),
	signal_value(A,T1),
	signal_value(B,T2),
	or(T1,T2,V).
	
signal_value(S,V):-
	and_gate(A,B,S),
	signal_value(A,T1),
	signal_value(B,T2),
	and(T1,T2,V).