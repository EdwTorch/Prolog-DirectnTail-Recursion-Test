sum_dir(0, 0) :- !.

sum_dir(N, Hasil) :-
    N > 0, Next is N - 1,
    sum_dir(Next, Resultafter),
    Hasil is Resultafter + N. 

sum_tail(N,Hasil):-
    sum_tails(N,0,Hasil).

sum_tails(0,Hasil,Hasil):- !.

sum_tails(N,Acc,Hasil):-
    Next is N-1, NewAcc is Acc + N,
    sum_tails(Next,NewAcc,Hasil).