
:-lib(ic).

item(pizza,12).
item(burger,14).
item(kingburger,18).
item(platSurprise,15).
%item(hotdog,3).
%item(cheeseburger,4).
%item(clubsandwich,5).
%item(fries,2).

mmult([],[],[]).
mmult([H1|Tail1],[H2|Tail2], [H3|Tail3]):-
    mmult(Tail1, Tail2, Tail3),
    H3 #= (H1 * H2).

concat([], [], []).
concat([H1|T1], [H2|T2], [H1 - H2|T]) :-
	concat(T1,T2,T).
 
menu(Amount,Order) :-
	findall(Price, item(_, Price), Prices),
	findall(Item, item(Item,_), Items),
	length(Prices, L),
	length(OrderList, L),
	OrderList #:: 0..1.0Inf,
	mmult(OrderList,Prices,LHS),
	ic_global:sumlist(LHS,OrderToCompute),
	OrderToCompute #= Amount,
	labeling(OrderList),
	concat(OrderList, Items, Order).
	
	