-module(testing_suite).

-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

test_auto() ->
    cucumberl:main().
    
