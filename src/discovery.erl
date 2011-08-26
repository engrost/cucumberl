-module(discovery).

-compile(export_all).
-include_lib("kernel/include/file.hrl").

run_steps(Modules, ArgList) ->
  lists:foldl(fun(Mod, undefined) -> 
        Mod:step(ArgList);
        (_, Acc) -> Acc
  end,
  undefined, Modules).

all_step_modules() ->
    Modules = load_all_code_files(),
	FilteredModuleInfo = lists:filter(
                           fun({module,Mod})-> 
                                   [{exports, Names}|_] = Mod:module_info(), 
                                   lists:any(
                                     fun({Elem,_})-> 
                                             Elem == step 
                                     end, 
                                     Names
                                   ) 
                           end, 
                           Modules
    ),
	lists:sort(lists:map(fun({module,Mod}) -> Mod end, FilteredModuleInfo)).

all_feature_files(Directory) ->
{ok, UnfilteredFeatureFiles} = file:list_dir(Directory),
lists:sort(lists:filter(
	fun(File) ->
			{ok,FileInfo} = file:read_file_info(Directory++File),
			case FileInfo#file_info.type of
				regular -> true;
				_ -> false
			end
	end,
	UnfilteredFeatureFiles)).

%% just helper function to ensure that all modules from project will be discovered
load_all_code_files() ->
    [ code:load_file(list_to_atom(filename:basename(M, ".beam"))) || 
        M <- filelib:wildcard("*.beam", "ebin/")].
