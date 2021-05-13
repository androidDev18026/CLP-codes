
:-lib(ic).

num_gen([L1,5,L3,L4,3],[R1,R2,0,R4,1]) :-
	[L1,L3,L4,R1,R2,R4] #:: 0..9,
	ic_global:alldifferent([0,1,3,5,L1,L3,L4,R1,R2,R4]),
	N1 #= 10^4*L1 + 5*10^3 + 10^2*L3 + 10*L4 + 3,
	N2 #= 10^4*R1 + 10^3*R2 + 0 + 10*R4 + 1,
	abs(N1-N2) #= 12848,
	labeling([N1,N2]).
	
	