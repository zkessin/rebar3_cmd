-module(rebar3_cmd).
-behaviour(provider).

-export([init/1, do/1, format_error/1]).


%% ===================================================================
%% Public API
%% ===================================================================

%% Called when rebar3 first boots, before even parsing the arguments
%% or commands to be run. Purely initiates the provider, and nothing
%% else should be done here.
-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider = providers:create([
            {name, "Create custom generated elm code"},          % The 'user friendly' name of the task
            {module, ?MODULE},          % The module implementation of the task
            {bare, true},               % The task can be run by the user, always true
            {deps, []},              % The list of dependencies
            {example, "rebar3 build_elm --command 'foo:bar()'"}, % How to use the plugin
            {opts, [
                    {cmd, $c, "command", string, "command to run"}
                   ]},                  % list of options understood by the plugin
            {short_desc, ""},
            {desc, ""}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.


%% Run the code for the plugin. The command line argument are parsed
%% and dependencies have been run.
-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    ok = run_cmd(State),
    {ok, State}.

%% When an exception is raised or a value returned as
%% `{error, {?MODULE, Reason}}` will see the `format_error(Reason)`
%% function called for them, so a string can be formatted explaining
%% the issue.
-spec format_error(any()) -> iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).


run_cmd(State) ->
    {Args, _} = rebar_state:command_parsed_args(State),
    case proplists:get_value(cmd, Args) of
        undefined -> ok;
        X ->
            io:format("X ~p", [X]),
            eval(X,[])
            
    end.


eval(Str,Environ) ->
    {ok,Scanned,_} = erl_scan:string(Str),
    {ok,Parsed} = erl_parse:parse_exprs(Scanned),
    erl_eval:exprs(Parsed,Environ).
