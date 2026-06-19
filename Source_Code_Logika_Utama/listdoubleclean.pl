list_double_direct([], []):- !.

list_double_direct([Head|Tail], FinalList) :-
    list_double_direct(Tail, Res), R is Head*2, FinalList = [R|Res].

% Tail Recursion (with Accumulator)
list_double_tail(List, Res) :- list_double_tailhelp(List, [], Res).

list_double_tailhelp([], Acc, Final) :-     
    reverse(Acc, Final),!. 

list_double_tailhelp([Head|Tail], Acc, Res) :-
    R is Head * 2, NextAcc = [R|Acc],