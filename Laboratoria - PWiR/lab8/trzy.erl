-module(trzy).
-compile([export_all]).


przetwarzaj()->
	receive
		{From,Liczba,liczba} -> From ! {odeslana, Liczba + 100}, przetwarzaj();
		{skoncz} -> koniec
	end.


make(ListaWatkow,0) -> ListaWatkow;
make(ListaWatkow, IleJeszcze)->
	make([spawn(?MODULE,przetwarzaj,[]) | ListaWatkow] ,IleJeszcze-1).

generujListe(0) -> [];
generujListe(N) ->
	[random:uniform(100) | generujListe(N-1)].

zakonczWatki([]) -> watki_zakonczone;
zakonczWatki([Watek | Reszta]) ->
	Watek ! {skoncz},
	zakonczWatki(Reszta).


wysylajZadania(Watki,[],_,_) -> zakonczWatki(Watki);
wysylajZadania(Watki,[LiczbaDoPrzetworzenia|Reszta],KtoryWatek, From)->
	Watek = lists:nth(KtoryWatek,Watki),
	Watek ! {From, LiczbaDoPrzetworzenia, liczba},
	if 
		KtoryWatek < length(Watki) ->
			wysylajZadania(Watki,Reszta,KtoryWatek+1,From);
		true -> wysylajZadania(Watki,Reszta, 1,From)
	end.


wypisz([]) -> io:format("");
wypisz(Lista) ->
	%io:format("~p ",[H]),
	%wypisz(T),
	io:format("Dostalem ~p przetworzonych liczb\n",[length(Lista)]).


odbierz(Lista) ->
	receive
		{odeslana, Liczba} -> 
			%io:format("~p ",[Liczba]),
			odbierz([Liczba|Lista])
		after 
			100 -> wypisz(Lista)
	end.



main() ->
	Watki = make([],1000),
	ListaLiczb = generujListe(1000000),
	ZbieraczWynikow = spawn(?MODULE, odbierz,[[]]),
	wysylajZadania(Watki,ListaLiczb,1,ZbieraczWynikow).
	


