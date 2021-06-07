%%% Lab 11

%%% Libraries Required.
:-use_module(library(ic_sets)).
:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(lists)).
:-use_module(library(ic_edge_finder)).
:-use_module(library(branch_and_bound)). 
:-import (::)/2 from ic_sets. %% Make sure that the :: comes from IC_SETS. 

%% Exercise 1

houses([1,3,4,5,6,10,12,14,15,17,20,22]).

fair_father(S1,S2,S3):-
	houses(H),
	length(H,N),
	intsets([S1,S2,S3],3,1,N),
	
	all_disjoint([S1,S2,S3]),
	Array =..[a|H],
	
	weight(S1,Array,Sum),
	weight(S2,Array,Sum),
	weight(S3,Array,Sum),
	
	all_disjoint([S1,S2,S3]),
	
	sums([S1,S2,S3],Array,129),	
	129 #= 3*Sum,
	
	labelSets([S1,S2,S3]),
	pprint([S1,S2,S3],N).
	
	
%%% Prints nicely the sets on screen.	
pprint([],_).
pprint([G|_Groups],Nums):-
	write(G), write("::"), 
	member(X,G),
	nth1(X,Nums,N), 
	write(N),write(" "),
	fail.
	
pprint([_|Groups],Nums):-
	nl, pprint(Groups,Nums).


%%% fair_father with N children
%%% Exec 11

fair_father_N(N,S):-
  houses(H),
  length(S,N),
  length(H,HousesL),

  intsets(S,N,1,HousesL),
  AHouses =..[[]|H],
  sum(H, SumH),
  constr_houses(S,AHouses,Cards,Sums,SumH, N),
 
  Cards #= HousesL,
  Sums #= SumH,

  all_disjoint(S),
  label_set(S).
    

label_set([]).
label_set([S|RestS]):-
  insetdomain(S,_,_,_),
  label_set(RestS).  


constr_houses([],_,_,_,_,_).
constr_houses([S|SAll], Houses, Card, TotalSumS, Total, N):-
  weight(S, Houses, SumS),
  #(S, C),
  SumS * N #= Total, 
  constr_houses(SAll, Houses, RestCard, RestSumS, Total, N),
  Card #= C + RestCard,
  TotalSumS #= SumS + RestSumS.
  
  

%% Exercise 2

value([10,30,45,50,65,70,75,80,90,100]).
weight([100,110,200,210,240,300,430,450,500,600]).

solve(N, Boxes, Cost) :-
	value(Values),
	weight(Weights),
	length(Weights, AllN),
	
	intsets(Boxes,N,1,AllN),
	all_disjoint(Boxes),
	Array1 =..[a|Values],
	Array2 =..[b|Weights],
	
	state_cons(Boxes, Array1, Array2, Cost),
	sumlist(Values, MaxV),
	Opt #= MaxV - Cost,
	
	bb_min(labelSets(Boxes), Opt, _).
	
	
state_cons([],_, _, 0).
state_cons([G|Groups], VA, WA, Cost) :-
	weight(G, WA, W),
	W #< 600, W #>= 0,
	weight(G, VA, V),
	state_cons(Groups, VA, WA, ACost),
	Cost #= ACost + V.
	
	
labelSets([]).
labelSets([G|Groups]):-
	insetdomain(G,_,_,_), 
	labelSets(Groups).	
		
