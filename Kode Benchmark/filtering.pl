% =============================================================================
% KASUS: FILTER / PARTISI LIST (Mewakili Cabang Kondisional & Multi-Akumulator)
% =============================================================================

% --- 1. Direct Recursion
filter_direct([], [], [], 0):-
    statistics(localused, MemPeak),
    mem_start(MemBefore),
    TotalLocalStack is (MemPeak - MemBefore) / 1024,
    format('Direct Recursion Peak  Local Stack: ~4f KB~n', [TotalLocalStack]),!.


filter_direct([H|T], Evens, Odds, TotalCount) :-
    % 1. Panggilan rekursif dilakukan paling awal
    filter_direct(T, Even, Odd, CountBefore),
    
    % 2. Operasi Aritmatika Penjumlah 
    TotalCount is CountBefore + 1,
    
    % 3. Pembagian Kondisional setelah rekursi
    (   (H mod 2)=:=0 
    ->  Evens = [H|Even], Odds = Odd
    ;   Odds = [H|Odd], Evens = Even
    ).


% --- 2. Tail Recursion 

filter_tail(List, Evens, Odds) :- 
    filter_tail(List, [], [], Evens, Odds).

filter_tail([], AccEven, AccOdd, FinalEven, FinalOdd) :-
    statistics(localused, MemPeak),
    mem_start(MemBefore),
    TotalLocalStack is (MemPeak - MemBefore) / 1024,
    format('Tail Recursion Peak Local Stack: ~4f KB~n', [TotalLocalStack]),
    reverse(AccEven, FinalEven),
    reverse(AccOdd, FinalOdd).

filter_tail([H|T], AccEven, AccOdd, Evens, Odds) :-
    ((H mod 2)=:=0), !,NextAccEven = [H|AccEven],
    filter_tail(T, NextAccEven, AccOdd, Evens, Odds). % Push ke akumulator genap


filter_tail([H|T], AccEven, AccOdd, Evens, Odds) :-
    ((H mod 2)=:=1),NextAccOdd = [H|AccOdd],
    filter_tail(T, AccEven, NextAccOdd, Evens, Odds). % Push ke akumulator ganjil

:- dynamic mem_start/1.

benchmark_filter_dir(N) :-
    % Generasi list acak/urut dari 1 sampai N


    findall(X, between(1, N, X), TargetList),
    format('=== BENCHMARK FILTER GANJIL-GENAP (N = ~w) ===~n', [N]),
    
    % 1. Uji Direct
    format('Running Direct Recursion...~n', []),
    garbage_collect,
    statistics(localused, MemStartDirect),
    statistics(globalused,GlobalBeforeDir),
    retractall(mem_start(_)), asserta(mem_start(MemStartDirect)),
    statistics(cputime, T0_Direct),
    
    filter_direct(TargetList,Even,Odd,_),

    _Dummy1 = Even,
    _Dummy2 = Odd,

    statistics(cputime, T1_Direct),
    statistics(globalused,GlobalAfterDir),
    
    TimeDirect is (T1_Direct - T0_Direct) * 1000,
    GlobalAlloc is (GlobalAfterDir - GlobalBeforeDir)/1024,
    
    format('Direct Recursion Global Stack Allocation: ~4f KB', [GlobalAlloc]),nl,
    format('Direct Recursion Time Execution: ~4f ms~n~n', [TimeDirect]).
    
    
benchmark_filter_tail(N):-
    findall(X, between(1, N, X), TargetList),
    format('=== BENCHMARK FILTER GANJIL-GENAP (N = ~w) ===~n', [N]),

    garbage_collect,
    
    statistics(localused, MemStartTail),
    retractall(mem_start(_)), asserta(mem_start(MemStartTail)),
    statistics(globalused,GlobalBeforeTail),
    statistics(cputime, T0_Tail),
    
    filter_tail(TargetList, Even,Odd),

    _Dummy = Even,
    _Dummy1 = Odd,

    statistics(globalused,GlobalAfterTail),
    statistics(cputime, T1_Tail),

    TimeTail is (T1_Tail - T0_Tail) * 1000,
    GlobalAlloc is (GlobalAfterTail - GlobalBeforeTail)/1024,
    format('Tail Recursion Global Stack Allocation: ~4f KB', [GlobalAlloc]),nl,
    format('Waktu Eksekusi: ~4f ms~n~n', [TimeTail]).

