/*
 * ?- magic(3,C,[1,9],1),labeling([ff],C).
 * C = [2, 7, 6, 9, 5, 1, 4, 3, 8] ;
 * C = [2, 9, 4, 7, 5, 3, 6, 1, 8] ;
 * C = [4, 3, 8, 9, 5, 1, 2, 7, 6] .
 */
magic(N,MagicNumbers,[InfDomain,SupDomain],Power) :-
    NumElements #= N*N,
    length(MagicNumbers, NumElements),
    MagicNumbers ins InfDomain..SupDomain,
    all_distinct(MagicNumbers),
    zs_maximum_at(MagicNumbers,_,MaxIndex),
    C is N / 2, Half is floor(C) + 2, MaxIndex #< Half,
    maplist(my_pow(Power), MagicNumbers, PoweredNumbers),
    once(split_list(PoweredNumbers,N,Rows)),
    rows_are_magic(Rows,SumTarget),
    diag_is_magic(Rows,0,SumTarget),
    transpose(Rows,Columns),
    matrix_rotated(Rows,RotatedRows),
    rows_are_magic(Columns,SumTarget),
    diag_is_magic(RotatedRows,0,SumTarget).

/*
 * ?- maplist(my_pow(2),[1,2,3],D).
 * D = [1, 4, 9].
 */
my_pow(Power,Number,Result) :-
    Result #= Number^Power.

/* https://stackoverflow.com/a/46622087 */
list_length(Size, List) :- length(List, Size).

/* https://stackoverflow.com/a/46622087 */
split_list(List, SubSize, SubLists) :-
    maplist(list_length(SubSize), SubLists),
    append(SubLists, List).

rows_are_magic(ListOfLists, C) :-
    maplist(equal_sum(C), ListOfLists).

equal_sum(B, List) :-
    sum(List, #=, B).

diag_is_magic(List,Current,Sum) :-
    list_length(Length, List),
    Length #= Current,
    Sum #= 0.

diag_is_magic(ListOfLists,Current,Sum) :-
    nth0(Current,ListOfLists,TmpList),
    nth0(Current,TmpList,TmpValue),
    Current0 #= Current + 1,
    once(diag_is_magic(ListOfLists,Current0,Sum0)),
    Sum #= Sum0 + TmpValue.

matrix_rotated(Xss, Zss) :-
    transpose(Xss, Yss),
    maplist(reverse, Yss, Zss).


/*
 * ?- zs_maximum_at([2,3,4],M,I).
 * I = 2, M = 4.
 */
zs_maximum_at(Zs,Max,Pos) :-
   maplist(#>=(Max),Zs),
   nth0(Pos,Zs,Max).
