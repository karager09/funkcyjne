-module(piec).
-compile([export_all]).


przetwarzaj(Lista, From)->
	PosortowanyKawalek = lists:sort(Lista),
	From ! {posortowana, PosortowanyKawalek}.


make(1, ListaLiczb, Zbieracz) -> spawn(?MODULE, przetwarzaj,[ListaLiczb, Zbieracz]);

make(N, ListaLiczb, Zbieracz) ->
	{L1, Reszta} = lists:split(length(ListaLiczb) div N, ListaLiczb),
	spawn(?MODULE, przetwarzaj, [L1, Zbieracz]),
	make(N-1, Reszta, Zbieracz).


sortuj(Lista, From) ->
	if 
		length(Lista) < 2 ->
			From ! {posortowana, Lista};
		true ->
			{L1, L2} = lists:split(length(Lista) div 2, Lista),
			spawn(?MODULE, sortuj, [L1, self()]),
			spawn(?MODULE, sortuj, [L2, self()]),
			receive
				{posortowana, Lista1} ->
					receive 
						{posortowana, Lista2} ->
							Zmergowana = merge(Lista1,Lista2,[]),
							From ! {posortowana, Zmergowana}
					end
			end
	end.


generujListe(0) -> [];
generujListe(N) ->
	[rand:uniform(100) | generujListe(N-1)].



wypisz([]) -> io:format("\n");
wypisz([H|T]) ->
	io:format("~p ",[H]),
	wypisz(T).
	%io:format("Dostalem ~p przetworzonych liczb\n",[length(Lista)]).

merge(L1,[], Suma) -> Suma ++ L1;
merge([],L2,Suma) -> Suma ++ L2;
merge([H1|T1], [H2|T2], Suma) ->
	if
		H1 < H2 -> merge(T1,[H2|T2], Suma ++ [H1]);
		true -> merge([H1|T1],T2, Suma ++ [H2])
	end.
		 


main() ->
	ListaLiczb = generujListe(100),
	sortuj(ListaLiczb, self()),
	receive
		{posortowana, Lista} ->
			wypisz(Lista)
	end.	


