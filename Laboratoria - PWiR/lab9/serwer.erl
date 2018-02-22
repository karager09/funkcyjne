-module(serwer).
-compile([export_all]).
-import(serwer_skel,[rpc/2,start/1]).

initAndStart() -> Stan = spawn(?MODULE, stan_serwera, [[]]),
	register(stan, Stan),
	start(?MODULE).

go() ->  start(?MODULE).


stan_serwera(Lista) ->
	receive
		{update, NowyStan} -> stan_serwera(NowyStan);
		{podajStan, Pid} -> Pid ! {Lista}, stan_serwera(Lista)
	end.

%% callback routines
init() -> stan ! {podajStan, self()},
	receive
		{Lista} -> Lista
	end.

updateStan() -> stan ! {update, getAll()}.
add(Nazwa, Ip) -> rpc(myids, {add, Nazwa, Ip}).
getIp(Nazwa) -> rpc(myids, {getIp, Nazwa}).
used(Nazwa) -> rpc(myids, {used, Nazwa}).
del(Nazwa)-> rpc(myids, {del, Nazwa}).
getAll() -> rpc(myids, {getAll}).




sprawdz_czy_istnieje(_, []) -> false;
sprawdz_czy_istnieje(Nazwa, [{Nazwa, _} | _]) -> true;
sprawdz_czy_istnieje(Nazwa, [_|T]) -> sprawdz_czy_istnieje(Nazwa, T).

usun(_,[], ListaZUsunietymi) -> ListaZUsunietymi;
usun(Nazwa, [{Nazwa, _}|T], ListaZUsunietymi) -> usun(Nazwa, T, ListaZUsunietymi);
usun(Nazwa, [H|T], ListaZUsunietymi)-> usun(Nazwa, T, ListaZUsunietymi ++ [H]).


szukaj(_, []) -> no_exist;
szukaj(Nazwa, [{Nazwa,Id}|_]) -> Id;
szukaj(Nazwa, [_|T]) -> szukaj(Nazwa, T).

handle({add,Nazwa, Ip},LId) -> 
  case sprawdz_czy_istnieje(Nazwa, LId) of
    true -> {error_reserved,LId};
    false -> {ok,[{Nazwa, Ip}|LId]}
  end;

handle({getIp, Nazwa}, LId) ->   
case sprawdz_czy_istnieje(Nazwa, LId) of
    false -> {error_no_exist,LId};
    true -> {szukaj(Nazwa, LId),LId}
  end;

handle({getAll},LId) -> {LId, LId};

handle({used,Nazwa},LId) -> {sprawdz_czy_istnieje(Nazwa, LId),LId};
handle({del,Nazwa},LId) -> {ok,usun(Nazwa, LId, [])}.


stop() -> 
	stan ! {update, getAll()},
	rpc(myids, {stop}).

