-module(jeden).
-compile([export_all]).

losujLiczbe(N) -> random:uniform(N).

losujiPrzeslijNLiczb(1,Pid) -> Pid!{losujLiczbe(100), liczba};
losujiPrzeslijNLiczb(N, Pid) ->
	Pid!{losujLiczbe(100), liczba},
	losujiPrzeslijNLiczb(N-1, Pid).

producent() ->
	Posrednik = spawn(?MODULE, posrednik, []),
	losujiPrzeslijNLiczb(10, Posrednik),
	Posrednik!{koniec},
	io:format("Koniec producenta\n").
	
	
otrzymujIPrzesylaj(Konsument)->
	receive
		{Liczba, liczba} -> Konsument!{Liczba * 2, pomnozona}, otrzymujIPrzesylaj(Konsument);
		{koniec} -> Konsument!{koniec}, io:format("Koniec posrednika\n")
	end.
			
	
posrednik()->
	Konsument = spawn(?MODULE, konsument, []),
	otrzymujIPrzesylaj(Konsument).


otrzymuj()->
	receive
		{Liczba, pomnozona} -> io:format("Otrzymalem liczbe: ~p\n", [Liczba]), otrzymuj();
		{koniec} -> io:format("Koniec konsumenta\n")
	end.

konsument() ->
	otrzymuj().
	
main() ->
	producent().
	
	
	
	

