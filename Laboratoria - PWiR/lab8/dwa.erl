-module(dwa).
-compile([export_all]).


print({gotoxy,X,Y}) ->
   io:format("\e[~p;~pH",[Y,X]);
print({printxy,X,Y,Msg}) ->
   io:format("\e[~p;~pH~p",[Y,X,Msg]);   
print({clear}) ->
   io:format("\e[2J",[]);
print({tlo}) ->
  print({printxy,2,4,1.2343}),  
  io:format("",[])  .
   
printxy({X,Y,Msg}) ->
   io:format("\e[~p;~pH~p~n",[Y,X,Msg]). 



losujLiczbe(N) -> random:uniform(N).

losujiPrzeslijNLiczb(1,Pid, DoWypisania) -> 
	Wylosowana = losujLiczbe(100),
	Pid!{Wylosowana, liczba},
	printxy({0,DoWypisania, Wylosowana}) ;
losujiPrzeslijNLiczb(N, Pid, DoWypisywania) ->
	Wylosowana = losujLiczbe(100),
	Pid!{Wylosowana, liczba},
	printxy({0,DoWypisywania,Wylosowana}),
	losujiPrzeslijNLiczb(N-1, Pid, DoWypisywania+1).

producent() ->
	N=15,
	printxy({0,0,producent}),
	Posrednik = spawn(?MODULE, posrednik, []),
	losujiPrzeslijNLiczb(N, Posrednik, 2),
	Posrednik!{koniec},
	printxy({0,N+2,'Koniec producenta'}).
	
	
otrzymujIPrzesylaj(Konsument,N)->
	receive
		{Liczba, liczba} -> Konsument!{Liczba * 2, pomnozona},
			printxy({20,N,Liczba}),
			otrzymujIPrzesylaj(Konsument,N+1);
		{koniec} -> Konsument!{koniec},
			printxy({20,N,"Koniec producenta"})
	end.
			
	
posrednik()->
	printxy({20,0,"Posrednik"}),
	Konsument = spawn(?MODULE, konsument, []),
	otrzymujIPrzesylaj(Konsument,2).


otrzymuj(N)->
	receive
		{Liczba, pomnozona} -> printxy({40,N,Liczba}), otrzymuj(N+1);
		{koniec} -> printxy({40,N,"Koniec konsumenta"})
	end.

konsument() ->
	printxy({40,0,"Konsument"}),
	otrzymuj(2).
	
main() ->
	print({clear}),
	producent().
	
	
	
	

