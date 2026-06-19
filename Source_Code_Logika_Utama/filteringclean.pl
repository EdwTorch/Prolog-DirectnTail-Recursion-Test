% --- 1. Direct/Head Recursion (Tanpa DPS) ---
filter_direct([], [], [], 0).
filter_direct([H|T], Evens, Odds, TotalCount) :-
    % 1. Panggilan rekursif dilakukan paling awal
    filter_direct(T, Even, Odd, CountBefore),
    
    % 2. Operasi Aritmatika Penjumlah 
    TotalCount is CountBefore + 1,
    
    % 3. Pembagian Kondisional setelah rekursi
    (   0 is H mod 2
    ->  Evens = [H|Even], Odds = Odd
    ;   Odds = [H|Odd], Evens = Even
    ).


% --- 2. Tail Recursion (Menggunakan Dua Akumulator) ---

filter_tail(List, Evens, Odds) :- 
    filter_tail(List, [], [], Evens, Odds).

filter_tail([], AccEven, AccOdd, FinalEven, FinalOdd) :- 
    reverse(AccEven, FinalEven),
    reverse(AccOdd, FinalOdd).

filter_tail([H|T], AccEven, AccOdd, Evens, Odds) :-
    ((H mod 2)=:=0), !,NextAccEven = [H|AccEven]
    filter_tail(T, NextAccEven, AccOdd, Evens, Odds). % Push ke akumulator genap
filter_tail([H|T], AccEven, AccOdd, Evens, Odds) :-
    ((H mod 2)=:=1),NextAccOdd = [H|AccOdd]
    filter_tail(T, AccEven, NextAccOdd, Evens, Odds). % Push ke akumulator ganjil