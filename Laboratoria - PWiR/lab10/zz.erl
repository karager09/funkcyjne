%%%-------------------------------------------------------------------
%%% @author ptm
%%% @copyright (C) 2017, ptm
%%% @doc
%%%
%%% @end
%%% Created : 2017-11-30 12:21:47.705561
%%%-------------------------------------------------------------------
-module(zz).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

%-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    {ok, Pid} = gen_server:start_link({local, myser}, ?MODULE, [], []),
	Pid.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    %{ok, #state{}}.
	{ok, {[], maps:new()}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({add, Key, Value}, _From, {History, Data}) ->
	NewState = {[{add, Key, Value}|History], maps:put(Key, Value, Data)},
	Reply = dodane,
	{reply, Reply, NewState};
	
	
handle_call({delete, Key}, _From, {History, Data}) ->
	Ok = maps:is_key(Key, Data),
	if 
		Ok ->  
				NewState = {[{delete,Key}|History], maps:remove(Key, Data)},
				Reply = usuniete,
				{reply, Reply, NewState};
		true ->
				Reply = nie_istnieje,
				{reply, Reply, {[{delete,Key}|History], Data}}
	end;
	
	
handle_call({get, Key}, _From, {History, Data}) ->
	Ok = maps:is_key(Key, Data),
	if 
		Ok ->  
				Reply = maps:get(Key, Data),
				{reply, Reply, {[{get, Key}|History],Data}};
		true ->
				Reply = nie_istnieje,
				{reply, Reply, {[{get, Key}|History],Data}}
	end;

handle_call({show_history}, _From, {History, Data}) ->
	Reply = {history, History},
	{reply, Reply, {History,Data}};
	
	
	
handle_call({get_all}, _From, {History, Data}) ->
	Reply = {ok, Data},
	{reply, Reply, {[{get_all}|History], Data}};	


handle_call({is_key, Key}, _From, {History, Data}) ->
	Reply = maps:is_key(Key, Data),
	{reply, Reply, {[{is_key,Key}|History], Data}};



handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.
	
	

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({delete_history}, {_, Data}) ->
	NewState = {[], Data},
    {noreply, NewState};

handle_cast({delete_data}, {History, _}) ->
	NewState = {History , maps:new()},
    {noreply, NewState};


handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
        {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================




