% Direct Recursion
:- dynamic mem_start/1.

sum_dir(0, 0) :- 
    statistics(localused, LocalAfter),
    mem_start(LocalBeforeDir),
    LocalPeak is (LocalAfter - LocalBeforeDir)/1024,
    format('Direct Recursion Local Stack Peak : ~4f KB', [LocalPeak]), nl,
    !.
sum_dir(N, Hasil) :-
    N > 0, Next is N - 1,
    sum_dir(Next, Resultafter),
    Hasil is Resultafter + N. 

sum_tail(N,Hasil):-
    sum_tails(N,0,Hasil).

sum_tails(0,Hasil,Hasil):- 
    statistics(localused, LocalAfter),
    mem_start(LocalBeforeTail),
    LocalPeak is (LocalAfter - LocalBeforeTail)/1024,
    format('Tail Recursion Local Stack Peak : ~4f KB', [LocalPeak]), nl,
    !.
sum_tails(N,Acc,Hasil):-
    Next is N-1, NewAcc is Acc + N,
    sum_tails(Next,NewAcc,Hasil).

benchmark_sum_dir(N):-
    format('==Benchmark Kasus Sumasi N = ~w',[N]),nl,
    garbage_collect,
    statistics(localused,LocalBeforeDir),
    statistics(globalused,GlobalBeforeDir),
    statistics(cputime,TimeBeforeDirect),
    retractall(mem_start(_)),
    assertz(mem_start(LocalBeforeDir)),
    
    sum_dir(N,_),

    statistics(globalused,GlobalAfterDir),
    statistics(cputime,TimeAfterDirect),
    GlobalAlloc is (GlobalAfterDir-GlobalBeforeDir)/1024,
    Runtime is TimeAfterDirect - TimeBeforeDirect,

    format('Direct Recursion Global Stack Alloc : ~4f KB', [GlobalAlloc]),nl,
    format('Direct Recursion Time Execution : ~4f ms ~n', [Runtime]).

benchmark_sum_tail(N):-
    format('==Benchmark Kasus Sumasi N = ~w',[N]),nl,
    garbage_collect,
    statistics(localused,LocalBeforeTail),
    statistics(globalused,GlobalBeforeTail),
    statistics(cputime,TimeBeforeTail),
    retractall(mem_start(_)),
    assertz(mem_start(LocalBeforeTail)),
    
    sum_tail(N,_),

    statistics(globalused,GlobalAfterTail),
    statistics(cputime,TimeAfterTail),
    GlobalAlloc is (GlobalAfterTail-GlobalBeforeTail)/1024,
    Runtime is TimeAfterTail - TimeBeforeTail,

    format('Tail Recursion Global Stack Alloc : ~4f KB', [GlobalAlloc]),nl,
    format('Tail Recursion Time Execution : ~4f ms ~n', [Runtime]).


