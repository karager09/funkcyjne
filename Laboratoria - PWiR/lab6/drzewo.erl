-module (drzewo).
-compile([export_all]).

losujLiczbe(N) -> random:uniform(N).

wstaw(Liczba, nil) -> {Liczba, nil, nil};
wstaw(Liczba, {nil, nil, nil}) -> {Liczba, nil, nil};
wstaw(Liczba, {Node, Left, Right}) ->
	if Liczba == Node -> {Node, Left, Right};
		Liczba < Node -> {Node, wstaw(Liczba, Left), Right};
		true -> {Node, Left, wstaw(Liczba, Right)}
	end.


wstawDoDrzewaGeneruj(0, _, Drzewo) -> Drzewo;
wstawDoDrzewaGeneruj(IleLiczb, Max, Drzewo) ->wstawDoDrzewaGeneruj(IleLiczb - 1, Max, wstaw(losujLiczbe(Max), Drzewo)).

tworzDrzewo(IleLiczb, Max) -> wstawDoDrzewaGeneruj(IleLiczb, Max, nil).


wstawZListyDoDrzewa([], Drzewo) -> Drzewo;
wstawZListyDoDrzewa([Liczba | T], Drzewo) -> wstawZListyDoDrzewa(T, wstaw(Liczba, Drzewo)).

generujZListy(Lista) -> wstawZListyDoDrzewa(Lista, nil).

preorder(nil) -> [];
preorder({Node, Left, Right}) ->
	preorder(Left) ++ [Node] ++ preorder(Right).
	

inorder(nil) -> [];
inorder({Node, Left, Right}) ->
	[Node] ++ inorder(Left) ++ inorder(Right).
	
postorder(nil) -> [];
postorder({Node, Left, Right}) ->
	postorder(Right) ++ [Node] ++ postorder(Left).
	
szukaj(_, nil) -> false;	
szukaj(Wartosc, {Node , Left, Right}) ->
	if Wartosc == Node -> true;
		true -> szukaj(Wartosc, Left) or szukaj(Wartosc, Right)
	end.
		

szukajIRzucWyjatek(_, nil) -> undefined;
szukajIRzucWyjatek(Wartosc, {Node, Left, Right}) ->
	if Wartosc == Node -> throw(istnieje);
	true -> szukajIRzucWyjatek(Wartosc, Left), szukajIRzucWyjatek(Wartosc, Right)
	end.


szukajWyjatkiem(Wartosc, Drzewo) ->
	try szukajIRzucWyjatek(Wartosc, Drzewo) of
	_ -> false
	catch
		istnieje -> true
	end.
	
