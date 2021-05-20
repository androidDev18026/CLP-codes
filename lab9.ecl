:-use_module(library(ic)).
:-use_module(library(branch_and_bound)).

%% 1.
worker(1,[4,1,3,5,6],[30,8,30,20,10]).
worker(2,[6,3,5,2,4],[140,20,70,10,90]).
worker(3,[8,4,5,7,10],[60,80,10,20,30]).
worker(4,[3,7,8,9,1],[30,40,10,70,10]).
worker(5,[7,1,5,6,4],[40,10,30,20,10]).
worker(6,[8,4,7,9,5],[20,100,130,220,50]).
worker(7,[5,6,7,4,10],[30,30,30,20,10]).
worker(8,[2,6,10,8,3],[50,40,20,10,60]).
worker(9,[1,3,10,9,6],[50,40,10,20,30]).
worker(10,[1,2,7,9,3],[20,20,30,40,50]).

solve(Works,Cost):-
	findall(X, worker(X,_,_), Wks),
	apply_cons(Wks, Works, Cost),
	alldifferent(Works),
	bb_min(labeling(Works),Cost,_).

apply_cons([], [], 0).

apply_cons([W|Rest], [T|RestT], Cost) :-
	worker(W, Tasks, Costs),
	element(I, Tasks, T),
	element(I, Costs, C),
	apply_cons(Rest,RestT, RestCost),
	Cost #= RestCost + C.


% 2.
num_gen_min([X1,5,X3,X4,3], [Y1,Y2,0,Y4,1], Cost) :-
	[X1,X3,X4,Y1,Y2,Y4] #:: [2,4,6,7,8,9], 
	alldifferent([X1,X3,X4,Y1,Y2,Y4]), 
	N1 #= X1*10000 + 5*1000 + X3*100 + X4*10 + 3,
	N2 #= Y1*10000 + Y2*1000 + 0 + Y4*10 + 1,
	Cost #= abs(N1-N2), 
	bb_min(labeling([X1,X3,X4,Y1,Y2,Y4]), Cost, _).

% 3.

student(alex,[4,1,3,5,6]).
student(nick,[6,3,5,2,4]).
student(jack,[8,4,5,7,10]).
student(helen,[3,7,8,9,1]).
student(maria,[7,1,5,6,4]).
student(evita,[8,4,7,9,5]).
student(jacky,[5,6,7,4,10]).
student(peter,[2,6,10,8,3]).
student(john,[1,3,10,9,6]).
student(mary,[1,6,7,9,10]).

solve2(S,Cost) :-
	findall(Name, student(Name,_), S),
	apply_prefs(S, Pref, Index, Assign),
	ic_global:sumlist(Index, Cost),
	alldifferent(Pref),
	bb_min(labeling(Pref),Cost,_).
	
	
apply_prefs([], [], [], []).

apply_prefs([S|Rest], [P|RestP], [I|RestI], [(S,P)|RestA]) :-
	student(S, Prefs),
	element(I, Prefs, P),
	apply_prefs(Rest,RestP, RestI, RestA).
	
% 4.

box(1,140).
box(2,200).
box(3,450).
box(4,700).
box(5,120).
box(6,300).
box(7,250).
box(8,125).
box(9,600).
box(10,650).
 
load_trucks(TA,LA,TB,LB):-
	findall(W, box(_,W), Boxes),
	length(TA,3),
	length(TB,4),
	assign_boxes(TA,Boxes,LA),
	LA #=< 1200,
	assign_boxes(TB,Boxes,LB),
	LB #=< 1350,
	append(TA,TB,AllT),
	alldifferent(AllT),
	Cost #= 2550 - (LA+LB),	
	bb_min(labeling(AllT), Cost, _).

assign_boxes([],_,0).

assign_boxes([Box|Boxes],List,W) :-
	element(Box,List,WBox),
	assign_boxes(Boxes, List, RestW),
	W #= WBox + RestW.

	
% 5.
