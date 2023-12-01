-module().

-behavior(gen_statem).

% API
-export([start_link/0]).

% Callbacks
-export([init/1]).
-export([callback_mode/0]).

%--- API -----------------------------------------------------------------------

start_link() -> gen_statem:start_link({local, ?MODULE}, ?MODULE, undefined, []).

%--- Callbacks -----------------------------------------------------------------

init(undefined) -> {ok, state, data}.

callback_mode() -> state_functions.
