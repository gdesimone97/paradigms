transcript('G', 'C').
transcript('C', 'G').
transcript('T', 'A').
transcript('A', 'U').

rna_transcription(Rna, Dna):-
    string_chars(Rna, NewList),
    maplist(transcript, NewList, ListDna),
    atomics_to_string(ListDna,Dna).
