%% @doc Websocket JSON-RPC Handler
%% @end

-module().

% Kraft Callbacks
%-export([handshake/3]).
-export([init/2]).
-export([message/2]).
-export([info/2]).

-behaviour(kraft_ws_jsonrpc).

-record(state, {session_key, session_pid, username}).

% --- Callbacks ----------------------------------------------------------------

handshake({Req0, _}, _Params, _State) ->
    {reply, 403, #{}, <<>>}.
    %{ok, Origin} = application:get_env(***, origin),
    %case cowboy_req:header(<<"origin">>, Req0, <<>>) of
    %    Origin->
    %        case ***_util:check_cookie(Req0) of %TODO: insert module
    %            {ok, Key, #{username := Username}} ->
    %                {ok, #state{session_key = Key, username = Username}};
    %            {error, Reason} ->
    %                logger:error("Error connecting to websocket: ~p", [Reason]),
    %                % FIXME: use timer or something better or trust frontend to
    %                % not reconnect to fast
    %                timer:sleep(200),
    %                {reply, 403, #{}, <<>>}
    %        end;
    %    _ ->
    %        logger:alert("Error connectiong to websocket: invalid origin", []),
    %        % FIXME: use timer or something better or trust frontend to not
    %        % reconnect to fast
    %        timer:sleep(200),
    %        {reply, 403, #{}, <<>>}
    %end.

init(_Req, #state{session_key = Session_key, username = Username} = State) ->
    % FIXME: move pg:join to _session
    %logger:notice("*** onnected via websocket", []),
    %pg:join(plc_update_receiver, self()),
    timer:send_interval(3600000, keep_session),
    pg:join({eresu_session, Session_key}, self()),
    %{ok, Child} = ***_session:connect(Session_key, Username),
    %monitor(process, Child),
    %State#state{session_pid = Child}.
    State.

message(_, _) -> error(function_clause).
%message({call, Method, Params, ID}, #state{username = Username} = State)
%  when Method =:= foo ->
%    case ***_session:handle_request(Username, {Method, Params}) of
%        {ok, Res} ->
%            {[{result, Res, ID}], State};
%        {error, {compile_error, Res}} ->
%            {[{error, -32001, <<"Compile error">>, Res, ID}], State};
%        {error, {app_exists, Res}} ->
%            {[{error, -32002, <<"Error application already exists">>, Res, ID}],
%             State};
%        {error, {no_app, Res}} ->
%            {[{error, -32003, <<"Error application does not exist">>, Res, ID}],
%             State};
%        {error, Reason} ->
%            logger:error("Error: ~p~n{~p, ~p}", [Reason, Method, Params]),
%            {[], State}
%    end.

info(keep_session, #state{session_key = Session_key} = State) ->
    ok = eresu_session:keep_session(Session_key),
    {[], State};
info({'DOWN', _Ref, process, Pid,  _Reason},
     #state{session_pid = Pid} = State) ->
    % Unexpected down of session
    {[{close, <<"Session died">>}], State};
info({exit, {eresu_session, Session_key}},
     #state{session_key = Session_key}=State) ->
    % login session died, probably logout in another tab
    {[{close, <<"Login session died">>}], State};
info(Info, State) ->
    logger:error("Unhandled info: ~p", [Info]),
    {[], State}.
