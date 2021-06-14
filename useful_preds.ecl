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
	
%% Union of 2 Lists
%% union_1/3

union_1(L1,L2,L):-
	setof(X,(member(X,L1);member(X,L2)),L).


%% union_2/3 (Alt.)
union_2([],L,L).
union_2([H|L1],L2,L):-
	member(H,L2),!,
	union_2(L1,L2,L).
	
union_2([H|L1],L2,[H|L]):-
	union_2(L1,L2,L).


%% Function result that takes 2 args.
%% func/3

root(X,N):- N is X^(1/2).
square(X,N):- N is X*X.

func(F, X1, Res):-
	C =.. [F,X1,Res],
	C.


%% Find path in graphs from node S(Start) --> F(Finish)
%% example goto/3 (from,to,cost)
goto(a,b,4).
goto(a,c,2).
goto(c,a,5).
goto(b,d,7).
goto(d,c,10).
goto(d,e,1).

dfs(From,To,Cost,Route):-
	dfs(From,To,[From],Cost,Route).

dfs(From, To, [From|Visited], Cost, [From,To]):-
	goto(From,To,Cost),
	not(member(To, Visited)).

dfs(From,To,Visited,Cost,[From|Route]):-
	goto(From, Temp, TCost),
	not(member(Temp,Visited)),
	dfs(Temp, To, [Temp|Visited], ACost, Route),
	Cost is TCost + ACost.

%% CLP Constraints - Scheduling

%% N Trucks cross bridge w/ 20 tn. max load - goal -> minimize time to go across.

car(alpha, 10, 4).
car(beta, 13,5).
car(gamma, 8, 3).
car(delta, 5, 4).
car(ephilon, 7, 1).
car(zita, 9, 3).
car(eta, 11, 6).

cross_bridge(Trucks, Starts, MinTime):-
	findall(T, car(T,_,_), Trucks),
	
	length(Trucks, N),
	length(Starts, N),
	
	Starts #:: 0..inf,
	
	apply_const_trucks(Trucks,Speeds,Starts,Weights,Ends),
	
	cumulative(Starts,Speeds,Weights,20),
	
	ic_global:maxlist(Ends,MinTime),
	
	bb_min(labeling(Starts),MinTime,bb_options{strategy:restart}).
	
apply_const_trucks([],[],[],[],[]).
apply_const_trucks([T|Trucks],[Speed|Speeds],[S|Starts],[W|Weights],[E|Ends]):-
	car(T,W,Speed),
	S + Speed #= E,
	apply_const_trucks(Trucks, Speeds, Starts, Weights, Ends).


%% 100 licences, 6 profs., lectures from 9-21, minimize end time

class(clp,3,40,3).
class(procedural,3,60,2).
class(analysis,4,50,2).
class(computer_sys,4,40,3).
class(algebra,3,40,4).
class(hpc,3,10,1).

lectures(Lectures, Starts, Makespan):-
	findall(Lect, class(Lect,_,_,_), Lectures),
	
	length(Lectures, N),
	length(Starts, N),
	
	Starts #:: 9..21,
	
	apply_const(Starts,Durations,Licences,Teachers,Ends,Lectures),
	
	cumulative(Starts,Durations,Teachers,6),
	cumulative(Starts,Durations,Licences,100),
	
	ic_global:maxlist(Ends,Makespan),
	
	bb_min(labeling(Starts),Makespan,bb_options{strategy:restart}).
	
	
apply_const([],[],[],[],[],[]).
apply_const([S|Starts],[Dur|Durs],[Lic|Lics],[Tch|Tchs],[End|Ends],[Lect|Lectures]):-
	class(Lect, Dur, Lic, Tch),
	S + Dur #= End,
	End #=< 21,
	apply_const(Starts,Durs,Lics,Tchs,Ends,Lectures).
	

%% IC Sets
nums([2, 4, 5, 11, 14, 17, 18, 21, 55, 67, 89, 98]).

split_nums(N, S):-
	nums(X),
	
	length(X,NN),
	intsets(S,N,1,NN),
	
	Array =.. [a|X],
	
	split_nums_const(S,Array,Card),
	Card #= NN,
	
	all_disjoint(S),
	
	labelingSets(S).
	
labelingSets([]).
labelingSets([S|Rest]):-
	insetdomain(S,increasing,_,_),
	labelingSets(Rest).
	

split_nums_const([],_,0).	
split_nums_const([S|RestS],Array,Cards):-
	#(S, C), C#>=2,
	weight(S,Array,SumW),
	SumW #> 20,
	split_nums_const(RestS,Array,RCards),
	Cards #= C + RCards.
