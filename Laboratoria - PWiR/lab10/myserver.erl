-module(myserver).
-compile([export_all]).
-import(zz, [start_link/0]).

% 'myser' to pid naszego serwera

start() -> start_link().


add(Key, Value) -> gen_server:call(myser, {add, Key, Value}).
delete(Key) -> gen_server:call(myser, {delete, Key}).
get(Key) -> gen_server:call(myser,{get, Key}).
show_history() -> gen_server:call(myser, {show_history}).
get_all() -> gen_server:call(myser, {get_all}).
is_key(Key) -> gen_server:call(myser, {is_key, Key}).
delete_history() -> gen_server:cast(myser,{delete_history}).
delete_data() -> gen_server:cast(myser, {delete_data}).
quit() -> gen_server:stop(myser).
