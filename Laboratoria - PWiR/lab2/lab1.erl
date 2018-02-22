%% -*- coding: utf-8 -*-
-module(lab1).
% nazwa modułu

-compile([export_all]).
% opcje kompilatora, w tym wypadku eksport wszystkich funkcji
% przydatne przy testowaniu
%
%-export([add/2, head/1, sum/1] ).
% lista funkcji jakie będą widoczne dla innych modułów

-vsn(1.0).
% wersja

-kto_jest_najlepszy(ja).
%dowolny atom możę być wykorzystany jako 'atrybut' modułu
%po kompilacji uruchom lab1:module_info().
%inne narzędzia mogą korzystać z tych informacji


-import(math,[pi/0]).
% lista modułów ,które są potrzebne.
% nie jest to konieczne


%funkcje

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add(a1,a2) -> a1+a2.
add(A1,A2) -> A1+A2.
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
head([H|_]) -> {glowa,H}.
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sum([]) -> 0;
sum([H|T]) -> H + sum(T).
%################################

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsum(L) -> tsum(L, 0). %tsum/1

tsum([H|T], S) -> tsum(T, S+H); %tsum/2 
tsum([],S) -> S.
% klauzule funkcji rozdzielana są średnikiem
% po ostatniej jst kropka
%################################


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obwod_kola(Promien) -> 
        Dwa_pi = 2 * pi(),  % wyrażenie pomocnicze
        Dwa_pi * Promien.   % ostatni element przed '.' lib ';' 
                            % to wynik funkcji
%################################
fact(0) -> 1;
fact(N) -> N * fact(N-1).
	

pole_tr(A,H) ->
	1/2 * A * H.

pole_szescianu(A) ->
	6*A*A.

len([]) -> 0;
len([_|T]) -> 1 + len(T).


amin([T]) -> T;
amin([H|T]) ->
	case H < amin(T) of
		true -> H;
		false -> amin(T)
	end.

amax([T]) -> T;
amax([H|T]) ->
	case H > amax(T) of
		true -> H;
		false -> amax(T)
	end.

tmin_max(L) -> {amin(L), amax(L)}.

lmin_max(L) -> [amin(L), amax(L)].

pole({kwadrat,X}) ->  X*X;
pole({kolo,X}) -> 3.14*X*X;
pole({trojkat,X,H}) -> 1/2 *X * H.

oblicz_pola([]) -> [];
oblicz_pola([H|T]) -> [pole(H)|oblicz_pola(T)].

lista_malejaca(0) -> [];
lista_malejaca(N) -> [N | lista_malejaca(N-1)].


konwertuj({celsjusz,S},Na_co_zamienic) ->
	case Na_co_zamienic of
		fahrenheit -> {fahrenheit, S*9/5+32};
		kelwin -> {kelwin, S+273}
	end;

konwertuj({kelwin,S},Na_co_zamienic) ->
	case Na_co_zamienic of
		fahrenheit -> {fahrenheit, (S-273)*9/5+32};
		celsjusz -> {celsjusz, S - 273}
	end;

konwertuj({fahrenheit,S},Na_co_zamienic) ->
	case Na_co_zamienic of
		celsjusz-> {celsjusz, 5/9 * (S - 32)};
		kelwin -> {kelwin, 5/9 * (S - 32) + 273}
	end.

generuj(0,_) -> [];
generuj(N,Litera) -> [Litera | generuj(N-1, Litera)].






