-module().

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

% API
-export([all/0]).
%-export([init_per_suite/1, end_per_suite/1]).
%-export([init_per_testcase/2, end_per_testcase/2]).

% Test Cases
-export([empty/1]).

%--- API -----------------------------------------------------------------------

all() -> [empty].

%--- Test Cases ----------------------------------------------------------------

empty(_) -> ok.
