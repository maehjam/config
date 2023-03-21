-module().

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

-export([all/0]).

-compile([export_all, nowarn_export_all]).

%--- API -----------------------------------------------------------------------

all() -> [F || {F, 1} <- ?MODULE:module_info(exports),
               lists:suffix("_test", atom_to_list(F))].

%--- Tests ---------------------------------------------------------------------
