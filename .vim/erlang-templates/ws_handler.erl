-module().

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

-behaviour(cowboy_websocket).

-record(state, {session_key, session_pid}).

% ------------------------------------------------------------------------------
% Websocket API
% ------------------------------------------------------------------------------

init(Req0, _State) ->
    {cowboy_websocket, Req0, #state{session_key = <<"default">>}}.
% TODO: validate login
%    case cowboy_req:host(Req0) of
%        <<"localhost">> -> 
%            case check_key(Req0) of
%                {ok, Key, Pid} ->
%                    {cowboy_websocket, Req0, #state{session_key = Key,
%                                                    session_pid = Pid}};
%                {error, _Reason} ->
%                    Req = cowboy_req:reply(403, State),
%                    {ok, Req, State}
%            end;
%        _ -> 
%            Req = cowboy_req:reply(403, State),
%            {ok, Req, State}
%    end.

%check_key(Req) ->
%    case cowboy_req:match_cookies([session_key], Req) of
%        #{session_key := Key} ->
%            case gproc:where({n, l, {eresu_session, Key}}) of
%                undefined -> {error, no_session};
%                Pid -> {ok, Key, Pid}
%            end;
%        _ -> {error, missing_session_key}
%    end.

websocket_init(#state{session_key = Key, session_pid = Pid} = State) ->
    {ok, Child} = supervisor:start_child(_session_sup, [Key, Pid]),
    {[], State#state{session_pid = Child}}.

websocket_handle(ping, #state{session_key = _Key} = State) ->
    {[pong], State};
    %TODO: forward ping to eresu session
    %case eresu:ping(Key) of
    %    pong -> {[pong], State};
    %    {error, timeout} ->
    %        Reply = json_encode(
    %                  reply({error_msg, <<"Session timeout">>}, <<"ping">>)),
    %        {[{close, Reply}], State}
    %end;
websocket_handle({text, Msg}, #state{session_key = Key} = State) ->
    case parse_msg(Msg) of
        {ok, {Method, Params, ID}} ->
            Res = _session:handle(Key, {Method, Params, ID}),
            {reply(Res, ID), State};
        {error, Reply, ID} ->
            %TODO: close websocket?
            {reply(Reply, ID), State}
    end;
websocket_handle(_Frame, State) -> {[], State}.

websocket_info({reply, Reply, ID}, State) ->
    {reply(Reply, ID), State};
websocket_info(_Info, State) -> {[], State}.

% ------------------------------------------------------------------------------
% Internal
% ------------------------------------------------------------------------------

parse_msg(Msg) ->
    Map = json_decode(Msg),
    ID = maps:get(id, Map, <<>>),
    Method = maps:get(method, Map, undefined),
    Params = maps:get(params, Map, #{}),
    case Method of
        undefined -> {error, <<"undefined method">>, ID};
        _ -> {ok, {Method, Params, ID}}
    end.

% When the method is handled in an asnychron cast the result will be `ok' and
% no direkt reply send
reply(ok, _) -> [];
reply(Res, ID) when is_tuple(Res) -> [{text, json_encode(reply1(Res, ID))}].

reply1({ok, Res}, ID) ->
    #{error => false, result => Res, id => ID};
reply1({ok, Res, Msg}, ID) when is_binary(Msg) ->
    #{error => false, result => Res, message => Msg, id => ID};
reply1({error, Errors}, ID) when is_list(Errors) ->
    #{error => true, errors => Errors, id => ID};
reply1({error, Msg}, ID) when is_binary(Msg) ->
    #{error => true, message => Msg, id => ID};
reply1({error, Result, Errors}, ID) when is_list(Errors) ->
    #{error => true, result => Result, errors => Errors, id => ID};
reply1({error, Result, Msg}, ID) when is_binary(Msg) ->
    #{error => true, result => Result, message => Msg, id => ID};
reply1({error, Result, Msg, Errors}, ID) when is_binary(Msg); is_list(Errors) ->
    #{error => true, result => Result, message => Msg, errors => Errors,
      id => ID}.

-spec json_encode(map()) -> binary().
json_encode(Data) -> jsx:encode(Data).

-spec json_decode(binary()) -> map().
json_decode(Data) -> jsx:decode(Data, [{labels, existing_atom}, return_maps]).
