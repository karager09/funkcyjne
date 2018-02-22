-module(winda).
-compile([export_all]).

%%%%%%%%%%%%%%%%%
nowy_czekajacy(Na_ktorym_jestem, Pid_pietra, Gdzie_chce_jechac, Od_ktorej_czekam) ->
	if Na_ktorym_jestem > Gdzie_chce_jechac -> Pid_pietra ! {czekam, dol, self()};
	true -> Pid_pietra ! {czekam, gora, self()}
	end,
	receive
		{na_ktore_pietro_chcesz, Winda} -> Winda ! {chce_na_pietro, Gdzie_chce_jechac},
		statystyki ! {godzina, self()},
		receive {godzina, Ile_kl} -> statystyki ! {czekalem_na_winde, Ile_kl - Od_ktorej_czekam} end,
			receive
				{jestem_na_pietrze, Gdzie_chce_jechac} -> 
					Winda ! {wysiadam_usun_mnie, self()},
					statystyki ! {godzina, self()},
						receive {godzina, Ile_klikniec} -> statystyki ! {czekalem_czasu, Ile_klikniec - Od_ktorej_czekam}
						end
			end
	end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nowe_pietro(Ktore_pietro, Tablica_pidow_czekajacych_gora, Tablica_pidow_czekajacych_dol) ->
	wyswietlaj ! {czekajacy_ludzie_na_pietrze, Ktore_pietro, length(Tablica_pidow_czekajacych_gora), length(Tablica_pidow_czekajacych_dol)},
	receive
		{czekam, dol, Pid_czekajacego} ->
			if 
				Tablica_pidow_czekajacych_dol == [] ->
					winda ! {czekam, dol, Ktore_pietro},
					nowe_pietro(Ktore_pietro, Tablica_pidow_czekajacych_gora, [Pid_czekajacego]);
				true -> 
					nowe_pietro(Ktore_pietro, Tablica_pidow_czekajacych_gora, [Pid_czekajacego | Tablica_pidow_czekajacych_dol])
			end;


		{czekam, gora, Pid_czekajacego} ->
			if 
				Tablica_pidow_czekajacych_gora == [] ->
					winda ! {czekam, gora, Ktore_pietro},
					nowe_pietro(Ktore_pietro, [Pid_czekajacego], Tablica_pidow_czekajacych_dol);
				true -> 
					nowe_pietro(Ktore_pietro, [Pid_czekajacego|Tablica_pidow_czekajacych_gora], Tablica_pidow_czekajacych_dol)
			end;

		{jestem_na_pietrze, W_ktora_strone_jade} ->
			if 
				W_ktora_strone_jade == dol ->
					winda ! {wsiadaja, Tablica_pidow_czekajacych_dol},
					nowe_pietro(Ktore_pietro, Tablica_pidow_czekajacych_gora, []);
				W_ktora_strone_jade == gora ->
					winda ! {wsiadaja, Tablica_pidow_czekajacych_gora},
					nowe_pietro(Ktore_pietro, [], Tablica_pidow_czekajacych_dol);
				W_ktora_strone_jade == dowolna ->
					if length(Tablica_pidow_czekajacych_dol) >= length(Tablica_pidow_czekajacych_gora) ->
						winda ! {wsiadaja, Tablica_pidow_czekajacych_dol},
						nowe_pietro(Ktore_pietro, Tablica_pidow_czekajacych_gora, []);
					true ->	
						winda ! {wsiadaja, Tablica_pidow_czekajacych_gora},
						nowe_pietro(Ktore_pietro, [], Tablica_pidow_czekajacych_dol)
					end
			end
	end.

%%%%%%%%%%%%%%%%%%%%%%%%%%
stworz_pietra(Numer_pietra, Numer_pietra) -> [spawn(?MODULE, nowe_pietro, [Numer_pietra,[],[]])];
stworz_pietra(Numer_pietra ,Ilosc_pieter) ->
	Pid_nowego = spawn(?MODULE, nowe_pietro, [Numer_pietra,[],[]]),
	[Pid_nowego|stworz_pietra(Numer_pietra + 1, Ilosc_pieter)].
%%%%%%%%%%%%%%%%%%%%%%



wyswietlaj(Ilosc_pieter) ->
	receive 
		{czekajacy_ludzie_na_pietrze, Numer_pietra, Ile_gora, Ile_dol} -> io:format("\e[~p;1H~p\e[~p;8H", [Ilosc_pieter-Numer_pietra+3,Numer_pietra, Ilosc_pieter-Numer_pietra+3]),wyswietlaj_ludzi(Ile_gora, Ile_dol),io:format("\e[~p;1H",[Ilosc_pieter+4]), wyswietlaj(Ilosc_pieter);
		{jestem_na_pietrze, Numer_pietra, Ilosc_osob} -> wyswietlaj_winde(Numer_pietra, Ilosc_osob,Ilosc_pieter,Ilosc_pieter),io:format("\e[~p;1H",[Ilosc_pieter+4]), wyswietlaj(Ilosc_pieter);
		{godzina, Ile_klikniec} -> io:format("\e[1;20HIle minęło:     ~.1f min\e[~p;1H",[Ile_klikniec, Ilosc_pieter+4]), wyswietlaj(Ilosc_pieter);
		{ilosc_osob, Ile_osob} -> io:format("\e[1;45HIle osob: ~p\e[~p;1H",[Ile_osob, Ilosc_pieter+4]),wyswietlaj(Ilosc_pieter);
		{sredni_czas_czekania_ogolem, Ile_wynosi} -> io:format("\e[2;30HŚredni czas ogolem: ~.2f\e[~p;1H",[Ile_wynosi, Ilosc_pieter+4]),wyswietlaj(Ilosc_pieter);
		{sredni_czas_czekania_na_winde, Ile_wynosi} -> io:format("\e[2;1HŚredni czas na winde: ~.2f\e[~p;1H",[Ile_wynosi, Ilosc_pieter+4]),wyswietlaj(Ilosc_pieter)
	end.

wyswietlaj_winde(_,_,0,Ilosc_pieter) -> io:format("\e[~p;1H",[Ilosc_pieter+4]);
wyswietlaj_winde(Numer_pietra, Ilosc_osob, Aktualne_pietro,Ilosc_pieter) ->
	if Aktualne_pietro == Numer_pietra ->
		io:format("\e[7m\e[~p;4H~p\e[0m\e[~p;1H", [Ilosc_pieter-Numer_pietra+3, Ilosc_osob, Ilosc_pieter +4]);
	true ->
		io:format("\e[~p;4H   \e[~p;1H",[Ilosc_pieter-Aktualne_pietro+3, Ilosc_pieter+4])
	end,
	wyswietlaj_winde(Numer_pietra, Ilosc_osob, Aktualne_pietro-1, Ilosc_pieter).

wyswietlaj_ludzi(0,0) -> io:format("\e[K",[]);
wyswietlaj_ludzi(0,Ile_dol) -> io:format("d",[]),wyswietlaj_ludzi(0, Ile_dol - 1);
wyswietlaj_ludzi(Ile_gora,Ile_dol) -> io:format("G",[]),wyswietlaj_ludzi(Ile_gora-1, Ile_dol).
		

wyswietlaj_panel(Ilosc_pieter) ->
	io:format("\e[1;1H++++Moja winda++++",[]),
	io:format("\e[~p;1Hstart, stop, stop_tworzenie, start_tworzenie, zmien_winda, zmien_tworzenie",[Ilosc_pieter+3]),
	io:format("\e[~p;1H",[Ilosc_pieter+4]).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

statystyki(Ile_klikniec, Ile_osob_ogolem, Ile_czekali_ogolem, Ile_czekali_na_winde, Ile_osob_na_winde) ->
	Ile_trwa_jeden_przejazd = 0.2,
	wyswietlaj ! {godzina, Ile_klikniec * Ile_trwa_jeden_przejazd},
	wyswietlaj ! {ilosc_osob, Ile_osob_ogolem},
	if Ile_osob_ogolem /= 0 -> wyswietlaj ! {sredni_czas_czekania_ogolem, Ile_czekali_ogolem/Ile_osob_ogolem}; true -> wyswietlaj ! {sredni_czas_czekania, nan} end,
	if Ile_osob_na_winde /= 0 -> wyswietlaj ! {sredni_czas_czekania_na_winde, Ile_czekali_na_winde/Ile_osob_na_winde}; true -> wyswietlaj ! {sredni_czas_czekania, nan} end,
	receive
		{godzina, Pid} -> Pid ! {godzina, Ile_klikniec}, statystyki(Ile_klikniec, Ile_osob_ogolem, Ile_czekali_ogolem, Ile_czekali_na_winde, Ile_osob_na_winde);
		{czekalem_czasu, Ile_czekalem} -> statystyki(Ile_klikniec, Ile_osob_ogolem + 1, Ile_czekali_ogolem + Ile_czekalem, Ile_czekali_na_winde, Ile_osob_na_winde);
		{zwieksz_licznik} -> statystyki(Ile_klikniec + 1, Ile_osob_ogolem, Ile_czekali_ogolem, Ile_czekali_na_winde, Ile_osob_na_winde);
		{czekalem_na_winde, Ile_czekalem} -> statystyki(Ile_klikniec, Ile_osob_ogolem, Ile_czekali_ogolem, Ile_czekali_na_winde + Ile_czekalem, Ile_osob_na_winde + 1)
	end.
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
odbierz_gdzie_chca_jechac(Na_ktore_pietra_jechac, 0) -> Na_ktore_pietra_jechac;
odbierz_gdzie_chca_jechac(Na_ktore_pietra_jechac, Ile_wsiadlo) ->
	receive
		{chce_na_pietro, Gdzie_chce_jechac} ->
			Nowe_gdzie_jechac = lists:umerge(lists:sort(Na_ktore_pietra_jechac), [Gdzie_chce_jechac]),
			odbierz_gdzie_chca_jechac(Nowe_gdzie_jechac, Ile_wsiadlo - 1)
	end.
		 	
		

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
winda(Pidy_pieter, Ilosc_pieter, Pidy_ludzi_w_windzie, Gdzie_jechac, Gdzie_czekaja_gora, Gdzie_czekaja_dol, Na_ktorym_jestem, W_ktora_strone_jade, Szybkosc) ->
	%wysylam komunikat do ludzi w windzie na ktorym jestem pietrze jakby chciali wysiasc	
	lists:map(fun(Czlowiek) -> Czlowiek ! {jestem_na_pietrze, Na_ktorym_jestem} end, Pidy_ludzi_w_windzie),
	receive %odbieram syglaly od zewnetrznych paneli ze ktos czeka
		{czekam, dol, Ktore_pietro} -> winda(Pidy_pieter, Ilosc_pieter, Pidy_ludzi_w_windzie, Gdzie_jechac,Gdzie_czekaja_gora, lists:umerge(lists:usort(Gdzie_czekaja_dol), [Ktore_pietro]), Na_ktorym_jestem, W_ktora_strone_jade, Szybkosc);
		{czekam, gora, Ktore_pietro} -> winda(Pidy_pieter, Ilosc_pieter, Pidy_ludzi_w_windzie, Gdzie_jechac, lists:umerge(lists:usort(Gdzie_czekaja_gora), [Ktore_pietro]) , Gdzie_czekaja_dol, Na_ktorym_jestem, W_ktora_strone_jade, Szybkosc);
		%ludzie wysiadaja
		{wysiadam_usun_mnie, Pid_wysiadajacego} -> winda(Pidy_pieter, Ilosc_pieter, lists:delete(Pid_wysiadajacego, Pidy_ludzi_w_windzie), lists:delete(Na_ktorym_jestem, Gdzie_jechac) , Gdzie_czekaja_gora, Gdzie_czekaja_dol, Na_ktorym_jestem, W_ktora_strone_jade, Szybkosc);
		{zmien_szybkosc, Jak_zmienic} -> winda(Pidy_pieter, Ilosc_pieter, Pidy_ludzi_w_windzie, Gdzie_jechac, Gdzie_czekaja_gora, Gdzie_czekaja_dol, Na_ktorym_jestem, W_ktora_strone_jade, erlang:trunc(Jak_zmienic * erlang:float(Szybkosc))+1);
		{stop} ->
			receive
				{start} -> null
			end;
		{start} -> null
		after 1 -> null
	end,
	%if Pidy_ludzi_w_windzie /= [] -> 
		lists:nth(Na_ktorym_jestem, Pidy_pieter) ! {jestem_na_pietrze, W_ktora_strone_jade},
		%true -> lists:nth(Na_ktorym_jestem, Pidy_pieter) ! {jestem_na_pietrze, dowolna}
	%end,
	receive
		{wsiadaja, Tablica_wsiadajacych} ->
		 	lists:map(fun(Czlowiek) -> Czlowiek ! {na_ktore_pietro_chcesz, self()} end, Tablica_wsiadajacych),
			Nowe_gdzie_jechac = odbierz_gdzie_chca_jechac(lists:usort(Gdzie_jechac), length(Tablica_wsiadajacych)),
		Nowi_jadacy = Tablica_wsiadajacych ++ Pidy_ludzi_w_windzie,
		Nowe_gdzie_czekaja = lists:delete(Na_ktorym_jestem, lists:umerge(lists:usort(Gdzie_czekaja_gora), lists:usort(Gdzie_czekaja_dol))),	
		

		if W_ktora_strone_jade == dol ->
			if 
				Nowe_gdzie_jechac == [] -> 
					if Nowe_gdzie_czekaja /= [] ->
						Min = lists:min(Nowe_gdzie_czekaja),
						if Min < Na_ktorym_jestem -> 
							Nowe_pietro = Na_ktorym_jestem - 1,
							Min_gora = lists:min(lists:umerge(Gdzie_czekaja_gora,[Ilosc_pieter])),
							Min_dol = lists:min(lists:umerge(Gdzie_czekaja_dol,[Ilosc_pieter])),
							if (Min_gora == Nowe_pietro) and (Min_dol /= Nowe_pietro)->
 										W_ktorym_kierunku_jechac = gora;
								true -> W_ktorym_kierunku_jechac = false
							end;
							true -> Nowe_pietro = Na_ktorym_jestem + 1, 
								W_ktorym_kierunku_jechac = false
						end;
						true -> Nowe_pietro = Na_ktorym_jestem, 
							W_ktorym_kierunku_jechac = false
					end;
				true -> Min = lists:min(Nowe_gdzie_jechac),
					W_ktorym_kierunku_jechac = false,
					if Min < Na_ktorym_jestem -> 
						Nowe_pietro = Na_ktorym_jestem - 1;
						true -> Nowe_pietro = Na_ktorym_jestem + 1
					end
			end;
		true ->
			if 
				Nowe_gdzie_jechac == [] -> 
					if Nowe_gdzie_czekaja /= [] ->
						Max_czekaja = lists:max(Nowe_gdzie_czekaja),
						if Max_czekaja > Na_ktorym_jestem -> Nowe_pietro = Na_ktorym_jestem + 1,
								Max_gora = lists:max(lists:umerge(Gdzie_czekaja_gora,[1])),
								Max_dol = lists:max(lists:umerge(Gdzie_czekaja_dol,[1])),
								if (Max_dol == Nowe_pietro) and (Max_gora /= Nowe_pietro)->  										W_ktorym_kierunku_jechac = dol;
								true -> W_ktorym_kierunku_jechac = false
								end;
							true -> Nowe_pietro = Na_ktorym_jestem - 1, 
								W_ktorym_kierunku_jechac = false
						end;
						true -> Nowe_pietro = Na_ktorym_jestem,
							W_ktorym_kierunku_jechac = false
					end;
				true ->
					W_ktorym_kierunku_jechac = false,
					Max = lists:max(Nowe_gdzie_jechac),
					if Max > Na_ktorym_jestem -> 
						Nowe_pietro = Na_ktorym_jestem + 1;
						true -> Nowe_pietro = Na_ktorym_jestem - 1
					end
			end
		end,
% wyswietlanie
		wyswietlaj ! {jestem_na_pietrze, Na_ktorym_jestem, length(Nowi_jadacy)},
		
		timer:sleep(Szybkosc),%na ile ma winda zaspac
		statystyki ! {zwieksz_licznik},
		
		if 	
			Nowe_pietro == 1 -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Nowe_gdzie_jechac, lists:delete(Na_ktorym_jestem,lists:delete(1,lists:usort(Gdzie_czekaja_gora))),lists:delete(Na_ktorym_jestem, Gdzie_czekaja_dol), Nowe_pietro, gora, Szybkosc);
			%Nowe_pietro == Ilosc_pieter -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Gdzie_czekaja_gora, lists:delete(Na_ktorym_jestem,lists:delete(Ilosc_pieter,lists:usort(Gdzie_czekaja_dol))), Nowe_gdzie_czekaja, Nowe_pietro, dol, Szybkosc);

			W_ktorym_kierunku_jechac == gora -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Nowe_gdzie_jechac, lists:delete(Na_ktorym_jestem,lists:delete(Nowe_pietro,lists:usort(Gdzie_czekaja_gora))),lists:delete(Na_ktorym_jestem, Gdzie_czekaja_dol), Nowe_pietro, W_ktorym_kierunku_jechac, Szybkosc);

			W_ktorym_kierunku_jechac == dol -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Nowe_gdzie_jechac, lists:delete(Na_ktorym_jestem, Gdzie_czekaja_gora), lists:delete(Na_ktorym_jestem, lists:delete(Nowe_pietro,lists:usort(Gdzie_czekaja_dol))), Nowe_pietro, W_ktorym_kierunku_jechac, Szybkosc);

			Nowe_pietro > Na_ktorym_jestem -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Nowe_gdzie_jechac, lists:delete(Nowe_pietro,lists:delete(Na_ktorym_jestem, lists:usort(Gdzie_czekaja_gora))),Gdzie_czekaja_dol, Nowe_pietro, gora, Szybkosc);
			true -> winda(Pidy_pieter, Ilosc_pieter, Nowi_jadacy, Nowe_gdzie_jechac, Gdzie_czekaja_gora, lists:delete(Nowe_pietro, lists:delete(Na_ktorym_jestem,lists:usort(Gdzie_czekaja_dol))), Nowe_pietro, dol, Szybkosc)
		end
	end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tworz_czekajacych(Pidy_pieter, Ilosc_pieter, Jak_szybko) ->
	Ile_czekac = rand:uniform(Jak_szybko), % co ile przychodzi nowa osoba
	%timer:sleep(Ile_czekac),
	receive 
		{zmien_szybkosc, Jak_zmienic} -> tworz_czekajacych(Pidy_pieter, Ilosc_pieter, erlang:trunc(Jak_zmienic * erlang:float(Jak_szybko)) );
		{start_tworzenie} -> null;
		{stop_tworzenie} ->
			receive
				{start_tworzenie} -> null
			end
		after Ile_czekac -> null
	end,
	Na_ktorym_jestem_org = rand:uniform(Ilosc_pieter),
	Czy_jestem_na_parterze = rand:uniform(2),
	if Czy_jestem_na_parterze == 1 -> Na_ktorym_jestem = 1;
		true -> Na_ktorym_jestem = Na_ktorym_jestem_org
	end,
	Gdzie_chce_jechac = rand:uniform(Ilosc_pieter),
	statystyki ! {godzina, self()},
	receive
		{godzina, Ile_klikniec} ->
		if 
			Na_ktorym_jestem /= Gdzie_chce_jechac -> 
				spawn(?MODULE, nowy_czekajacy, [Na_ktorym_jestem, lists:nth(Na_ktorym_jestem, Pidy_pieter), Gdzie_chce_jechac, Ile_klikniec]);
			true -> null
		end
	end,
	tworz_czekajacych(Pidy_pieter, Ilosc_pieter, Jak_szybko).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
co_zrobic(Ilosc_pieter) ->
	{ok, [Atom]} = io:fread("Co zrobic> ", "~a"),
		if Atom == stop -> winda ! {stop};
			Atom == start -> winda ! {start};
			Atom == stop_tworzenie -> tworzenie ! {stop_tworzenie};
			Atom == start_tworzenie -> tworzenie ! {start_tworzenie};
			Atom == zmien_tworzenie ->
				io:format("\e[~p;1H\e[K", [Ilosc_pieter+4]),
				{Czy_ok, Args} = io:fread("Jak zmienic> ", "~f"),
				if (Czy_ok == ok) ->
					[Jak_zmienic] = Args,
					tworzenie ! {zmien_szybkosc, Jak_zmienic};
					true -> null
				end;
			Atom == zmien_winda ->
				io:format("\e[~p;1H\e[K", [Ilosc_pieter+4]),
				{Czy_ok, Args} = io:fread("Jak zmienic> ", "~f"),
				if (Czy_ok == ok) ->
					[Jak_zmienic] = Args,
					winda ! {zmien_szybkosc, Jak_zmienic};
					true -> null
				end;
			true -> null
		end,
	io:format("\e[~p;1H\e[K", [Ilosc_pieter+4]),
	co_zrobic(Ilosc_pieter).


main() -> 
	Ilosc_pieter = 15,
	io:format("\e[2J",[]),
	wyswietlaj_panel(Ilosc_pieter),	
	Pid_wyswietlaj = spawn(?MODULE, wyswietlaj, [Ilosc_pieter]),
	register(wyswietlaj, Pid_wyswietlaj),
	register(statystyki, spawn(?MODULE, statystyki, [0, 0, 0, 0, 0])),
	
	Pidy_pieter = stworz_pietra(1, Ilosc_pieter),
	Pid_winda = spawn(?MODULE, winda, [Pidy_pieter, Ilosc_pieter, [], [], [], [], 1, gora, 1000]),
	register(winda, Pid_winda),
	register(tworzenie, spawn(?MODULE, tworz_czekajacych, [Pidy_pieter, Ilosc_pieter, 2000])), %poczatkowa szybkosc tworzenia
	co_zrobic(Ilosc_pieter).
	%tworz_czekajacych(Pidy_pieter, Ilosc_pieter).
	%io:format("~p\n",[lists:nth(5,Pidy_pieter)]).
	



