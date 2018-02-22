-module (lab2).
-compile(export_all).

map_append(Key, Value, Map) ->
	Map#{ Key => Value}.
	
map_update(Key, Value, Map) ->
	Map#{ Key := Value}.
	
	
wypisz_element({Key, Value}) -> io:format("~p --> ~p ~n",[Key, Value]).

%Fun = fun(Key, Value) -> Key + Value end.
	
wypisz_liste([]) -> io:format("~n");
wypisz_liste([H | T]) -> wypisz_element(H), wypisz_liste(T).
%wypisz_liste(Lista) -> [wypisz_element(X) || X <- Lista].

map_display(Map) -> wypisz_liste(maps:to_list(Map)).  %można mapa użyć, nawet lepiej


%wypisz(Map) ->
%	maps:map(Fun, Map).


zlicz_slowa() ->
	C = file:read_file("raz.txt"),{ok, Dane} =C,
	Txt = binary:bin_to_list(Dane),
	Pojedyncze = string:tokens(Txt, " \n,."),
	Map = dodaj_wszystkie(Pojedyncze, #{}),
	map_display(Map).

sprawdz_i_dodaj(Slowo, Map) ->
	case maps:is_key(Slowo, Map) of
		false -> map_append(Slowo, 1, Map);
		true -> Ilosc = maps:get(Slowo, Map),
			map_update(Slowo, Ilosc + 1, Map)
	end.
		
		
dodaj_wszystkie([], Map) -> Map;

dodaj_wszystkie([Slowo | Reszta], Map) ->
	NewMap = sprawdz_i_dodaj(Slowo, Map),
	dodaj_wszystkie(Reszta, NewMap).


