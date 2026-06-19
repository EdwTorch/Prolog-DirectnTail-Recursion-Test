:- dynamic mem_start/1.

generate_list(N, List) :- findall(X, between(1, N, X), List).

% Direct Recursion
list_double_direct([], []):- 
    statistics(localused, LocalAfter),
    mem_start(LocalBeforeDir),
    LocalPeak is (LocalAfter - LocalBeforeDir)/1024,
    format('Direct Recursion Local Stack Peak : ~4f KB', [LocalPeak]), nl,
    !.
list_double_direct([Head|Tail], FinalList) :-
    list_double_direct(Tail, Res), R is Head*2, FinalList = [R|Res].

% Tail Recursion (with Accumulator)
list_double_tail(List, Res) :- list_double_tailhelp(List, [], Res).

list_double_tailhelp([], Acc, Final) :-     
    statistics(localused, LocalAfter),
    mem_start(LocalBeforeTail),
    LocalPeak is (LocalAfter - LocalBeforeTail)/1024,
    format('Tail Recursion Local Stack Peak : ~4f KB', [LocalPeak]), nl,
    reverse(Acc, Final),!. 


list_double_tailhelp([Head|Tail], Acc, Res) :-
    R is Head * 2, NextAcc = [R|Acc],
    list_double_tailhelp(Tail, NextAcc, Res).

benchmark_list_dir(N):-
    format('Benchmark Kasus Manipulasi List N = ~w', [N]),nl,
    generate_list(N,ListDir),
    
    garbage_collect,
    statistics(localused,LocalBeforeDir),
    statistics(globalused,GlobalBeforeDir),
    statistics(cputime,TimeBeforeDirect),
    retractall(mem_start(_)),
    assertz(mem_start(LocalBeforeDir)),
    
    list_double_direct(ListDir,_),

    statistics(globalused,GlobalAfterDir),
    statistics(cputime,TimeAfterDirect),
    GlobalAlloc is (GlobalAfterDir-GlobalBeforeDir)/1024,
    Runtime is TimeAfterDirect - TimeBeforeDirect,

    format('Direct Recursion Global Stack Alloc : ~4f KB', [GlobalAlloc]),nl,
    format('Direct Recursion Time Execution : ~4f ms ~n', [Runtime]).

benchmark_list_tail(N):-
    format('Benchmark Kasus Manipulasi List N = ~w', [N]),nl,
    generate_list(N,ListTail),
    
    garbage_collect,
    statistics(localused,LocalBeforeTail),
    statistics(globalused,GlobalBeforeTail),
    statistics(cputime,TimeBeforeTail),
    retractall(mem_start(_)),
    assertz(mem_start(LocalBeforeTail)),
    
    list_double_tail(ListTail,Hasil),
    _Dummy = Hasil,
    statistics(globalused,GlobalAfterTail),
    statistics(cputime,TimeAfterTail),
    GlobalAlloc is (GlobalAfterTail-GlobalBeforeTail)/1024,
    Runtime is TimeAfterTail - TimeBeforeTail,

    format('Tail Recursion Global Stack Alloc : ~4f KB', [GlobalAlloc]),nl,
    format('Tail Recursion Time Execution : ~4f ms ~n', [Runtime]).