-module().

-behavior(gen_statem).

% API
-export([start_link/0]).

% Callbacks
-export([init/1]).
-export([callback_mode/0]).
-export([handle_event/4]).

%--- API -----------------------------------------------------------------------

start_link() -> gen_statem:start_link({local, ?MODULE}, ?MODULE, undefined, []).

%--- Callbacks -----------------------------------------------------------------

init(undefined) -> {ok, state, data}.

callback_mode() -> handle_event_function.

handle_event({call, _From}, EventData, State, _Data) ->
    error({unhandled_call, EventData, State});
handle_event(Event, EventData, State, _Data) ->
    error({unhandled_event, Event, EventData, State}).
