weight(10).
weight(20).
weight(30).
weight(50).
weight(60).
weight(90).
weight(100).
weight(150).
weight(250).
weight(500).

:-lib(ic).

balance_lights(Weights, Sum) :-
	Weights = [W1,W2,W3,W4],
	findall(W, weight(W), List),
	Weights #:: List,
	ic_global:alldifferent(Weights),
	5*W1 #= 5*W2 + 20*W3 + 40*W4,
	labeling(Weights),
	sum(Weights, Sum).
	