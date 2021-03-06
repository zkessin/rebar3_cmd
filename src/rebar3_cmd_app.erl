%%%-------------------------------------------------------------------
%% @doc rebar3_cmd public API
%% @end
%%%-------------------------------------------------------------------

-module(rebar3_cmd_app).

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    rebar3_cmd_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
