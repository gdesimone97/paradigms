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

signal_value(r, V):-
	signal_value(a, R),
	not(R, V).

signal_value(s, V):-
	signal_value(r, R1),
	signal_value(b, R2),
	and(R1, R2, V).
	
signal_value(t, V):-
	signal_value(s, R1),
	signal_value(c, R2),
	or(R1, R2, V).

signal_value(x, V):-
	signal_value(t, R1),
	not(R1, V).

signal_value(S,V):-
	input_signal(S, V).