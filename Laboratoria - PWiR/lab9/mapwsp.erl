-module (mapwsp).
-compile([export_all]).



przydziel_zadania([],_,Where) -> [];%Where ! {juz};
przydziel_zadania([H|T], Funkcja, Where) ->
	spawn(?MODULE, policz_i_wyslij, [Funkcja, H, Where]),
	przydziel_zadania(T, Funkcja, Where).

map_wsp(Lista, Funkcja) ->
	Zbieracz = spawn(?MODULE, zbieraj_wartosci, [[],self()]),
	przydziel_zadania(Lista, Funkcja, Zbieracz),
	receive
		{Obliczone} -> Obliczone
	end.
		
			
	

policz_i_wyslij(Funkcja, H, From) ->
	Obliczone = Funkcja(H),
	From ! {liczba, Obliczone}.


pomnoz(Element) -> Element * Element.


zbieraj_wartosci(Lista, From) -> 
	receive
		{liczba, Liczba} -> zbieraj_wartosci(Lista ++ [Liczba], From)%, io:format("~p ",[Liczba])
		after 200 -> From ! {Lista}
	end.

main() ->
	map_wsp([1,2,3,4,542314321], fun pomnoz/1).
