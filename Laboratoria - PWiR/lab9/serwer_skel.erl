-module(serwer_skel).
-compile([export_all]).


start(Mod) ->
    Id = spawn(fun() -> loop(Mod, Mod:init()) end),
	register(myids, Id).

do_upgrade(Pid, Mod) -> rpc(Pid, {do_upgrade, Mod}).

rpc(Pid, Request) ->
    Ref = make_ref(),
    Pid ! {self(),Ref,Request},
    receive
        {Ref, Response} -> Response
    end.


loop(Mod, State) ->
    receive
	{From, Ref, {do_upgrade,NewMod}} -> From ! {Ref, ack}, loop(NewMod, State);
	{From, Ref, {stop}} -> From ! {Ref, 'Zakonczylem prace serwera'};
	{From, Ref,Request} -> {Response, State1} = Mod:handle(Request, State),
                               From ! {Ref, Response},
                               loop(Mod, State1)
	
    end.
