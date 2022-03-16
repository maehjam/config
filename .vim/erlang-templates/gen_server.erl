-module().

-behaviour(gen_server).

% API
-export([start_link/0]).

% Callbacks
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).

% API

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, undefined, []).

% Callbacks

init(undefined) -> {ok, undefined}.

handle_call(Request, _From, _State) ->
    error({undefined_call, Request}).

handle_cast(Msg, _State) ->
    error({undefined_cast, Msg}).

handle_info(Info, State) ->
    logger:alert("Unexpected info: ~p", [Info]),
    {noreply, State}.
