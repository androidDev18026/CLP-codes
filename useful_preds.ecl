:-lib(ic).
:-lib(ic_edge_finder).
:-lib(branch_and_bound).

%%% Some useful predicates with lists and more - 11.6.21 

%% Rotate Left 
%% rleft/3
%% [1,2,3,4] -> 2 --> [3,4,1,2]

rleft(N,L,Res):-
	length(L, NL),
	mod(N,NL,NN),
	append(L1,L2,L),
	length(L1,NN),
	append(L2,L1,Res), !.

%% Test member
%% mem/2

mem(X,[X|_]):-!.
mem(X,[_|T]):- mem(X,T).

%% Find Sublist
%% sublist/3

sublist(SList, List):-
	append(_L1,SList,List),!.

sublist(SList, List):-
	append(SList,_L1,List),!.

sublist(SList, [_|List]):-
	sublist(SList,List).

%% List of items are ALL members
%% i.e. [1,2,4] members of [1,2,3,4,5,6]

sublist_mem(El, List):-
	findall(X, (member(X,El),member(X,List)), El).

%% Delete All X from List
%% delete_all/3

delete_all(Y, L1, L):-
	findall(X, (member(X, L1), X \== Y), L).

%% Delete All X from List (Alt.)
%% delete_all_2/3

delete_all_2(_,[],[]).
delete_all_2(X,[H|T],[H|L]) :-
	X\==H,!,
	delete_all_2(X,T,L).
	
delete_all_2(X,[_|T],L) :-
	delete_all_2(X,T,L).

%% Delete One 
delete_one(X, [X|T], T):-!.
delete_one(X, [H|T], [H|Res]):-
	delete_one(X,T,Res).

%% Concatenate 2 Lists
concat([],L,L).
concat([H|L1],L2,[H|L]):-
	concat(L1,L2,L).

%% Difference of 2 Lists
%% diff/3

diff(L1,L2,Diff):-
	findall(X, (member(X,L1),not(member(X,L2))), Diff).


%% diff_2/3
diff_2([],_,[]).
diff_2([H|L1],L2,[H|L]):-
	not(member(H,L2)),!,
	diff_2(L1,L2,L).

diff_2([_|L1],L2,L):-
	diff_2(L1,L2,L).


%% Intersection of 2 Lists
%% intersect/3
intersect(L1,L2,L):-
	findall(X, (member(X,L1),member(X,L2)), L).

%% intersect_2/3
intersect_2([],_,[]).
intersect_2([G1|L1],L2,[G1|L]):-
	member(G1,L2),!,
	intersect_2(L1,L2,L).

intersect_2([_|L1],L2,L):-	
	intersect_2(L1,L2,L).
