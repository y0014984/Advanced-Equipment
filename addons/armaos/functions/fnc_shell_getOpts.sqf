// Parse command string and return set command arguments

// option short form:
// 'ls -a' or combining multiple arguments 'ls -alh'
// option long form:
// 'ls --all -l --human-readable'
// option with argument:
// 'ls --width=5'

// _short = single char or "" if not set
// _long = multiple chars or "" if not set

params ["_options", "_commandOpts"];

private _result = [];
// _resultOpts is a hashmap to allow overwriting with 'set' if one option occurs multiple times
private _resultOpts = createHashMap;
private _resultThings = [];

// initialize options and set default values
{
	private _optVarName = _x select 0;
    private _optDefaultValue = _x select 4;
	_resultOpts set [_optVarName, _optDefaultValue];
} forEach _commandOpts;

{
	if ( ((_x select [0, 2]) isEqualTo "--") && ((count _x) >= 4) ) then
	{
		// long form; min. count 4, because "--" + 2 or more chars
		private _resultsLongForm = [_x, _commandOpts] call AE3_armaos_fnc_shell_getOptsParseLongForm;
		_resultOpts merge [_resultsLongForm, true]; // overwrite existing
		continue;
	};

	if ( ((_x select [0, 1]) isEqualTo "-") && ((count _x) >= 2) ) then
	{
		// short form; min. count 2, because "-" + 1 or more chars
		private _resultsShortForm = [_x, _commandOpts] call AE3_armaos_fnc_shell_getOptsParseShortForm;
		_resultOpts merge [_resultsShortForm, true]; // overwrite existing
		continue;
	};

	// if it's not an option/arg, it must be something else, perhaps path/dir/ip/text or other
	_resultThings pushBack _x;
} forEach _options;

// add things as the additional reserved var "_ae3OptsThings" to the results
_resultOpts set ["_ae3OptsThings", _resultThings];

_result = _resultOpts toArray false; // Convert HashMap to Array

_result;