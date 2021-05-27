:-use_module(library(ic)).
:-use_module(library(ic_global)).
:-use_module(library(branch_and_bound)).
:-use_module(library(ic_edge_finder)).

museum(Starts) :-
	Starts = [St1,St2,St3,St4],
	Ends = [E1,E2,E3,E4],
	Starts #:: 0..10,
	Ends #:: 0..10,
	St1 + 2 #= E1,
	St2 + 1 #= E2,
	St3 + 2 #= E3,
	St4 + 5 #= E4,
	ic_global:maxlist(Ends,MakeSpan),
	cumulative(Starts,[2,1,2,5],[60,30,50,40],100),
	bb_min(labeling(Starts),MakeSpan,bb_options{strategy:restart}).
			

reading(course1,3,12).
reading(course2,5,20).
reading(course3,2,8).
reading(course4,7,22).

schedule_reads(S) :-
	findall(C, reading(C,_,_), Courses),
	length(Courses, N),
	length(S,N),
	S #:: 1..31,
	reads(Courses,S, Durations),
	ic_global:maxlist(Durations,MakeSpan),
	disjunctive(S,Durations),
	labeling(S).
	
reads([],[],[]).
reads([C|Rest],[S|RestS], [Dur|Durations]) :-
	reading(C, Dur, Date),
	S + Dur #< Date,
	reads(Rest,RestS,Durations).

exec3(Starts) :-
	Starts = [SA1,SA2,SA3,SB1,SB2,SB3,SC1,SC2,SC3],
	Ends = [EA1,EA2,EA3,EB1,EB2,EB3,EC1,EC2,EC3],
	
	Starts #:: 0..1000,
	Ends #:: 0..1000,
	
	SA1 + 5 #= EA1,
	SA1 #>= 5,
	SA2 + 20 #= EA2,
	SA3 + 15 #= EA3,
	SA3 #>= 10,
	EA1 #=< SA2,
	EA2 #=< SA3,
	
	SB1 + 5 #= EB1,
	SB2 + 10 #= EB2,
	SB3 + 5 #= EB3,
	SB2 #>= 10,
	SB3 #>= 5,
	EB1 #=< SB2,
	EB2 #=< SB3,
	
	SC1 + 10 #= EC1,
	SC2 + 15 #= EC2,
	SC3 + 10 #= EC3,
	SC2 #>= 10,
	SC3 #>= 20,
	EC1 #=< SC2,
	EC2 #=< SC3,

	
	disjunctive([SA1,SB1,SC1], [5,5,10]),
	disjunctive([SA2,SB2,SC2], [20,10,15]),
	disjunctive([SA3,SB3,SC3], [15,5,10]),
	
	Cost #= ((EA1 - 20) + (EA2 - 40) + (EA3 - 35) +
			(EB1 - 30) + (EB2 - 25) + (EB3 - 30) +
			(EC1 - 15) + (EC2 - 35) + (EC3 - 35)),
	
	bb_min(labeling(Starts),Cost, _).