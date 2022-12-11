// Parse command string and return set command arguments

// option short form:
// 'ls -a' or combining multiple arguments 'ls -alh'
// option long form:
// 'ls --all -l --human-readable'
// option with argument:
// 'ls --width=5'

// _short = single char or "" if not set
// _long = multiple chars or "" if not set

params ["_computer", "_options", "_commandOpts"];

private _result = [];
// _resultOpts is a hashmap to allow overwriting with 'set' if one option occurs multiple times
private _resultOpts = createHashMap;
private _requiredOpts = createHashMap;
private _resultThings = [];

// filter for '-h/--help'
if (((count _options) == 1) && (((_options select 0) isEqualTo "-h") || ((_options select 0) isEqualTo "--help"))) exitWith
{
	[_computer, _commandOpts] call AE3_armaos_fnc_shell_getOptsPrintHelp;
	_resultOpts set ["_ae3OptsSuccess", false];
	_result = _resultOpts toArray false; // Convert HashMap to Array
	_result;
};

// initialize options and set default values or keep track of required options
{
	private _optVarName = _x select 0;
	private _shortOpt = _x select 1;
	private _longOpt = _x select 2;
	private _optType = _x select 3;
	private _optDefaultValue = _x select 4;
	private _optRequired = _x select 5;
	private _optHelp = _x select 6;
	private _optSelect = [];

	if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then { _optSelect = _x select 7; };

	private _optName = [_shortOpt, _longOpt, _optType, _optSelect] call AE3_armaos_fnc_shell_getOptsFormatOptsName;

	if (_optRequired) then { _requiredOpts set [_optVarName, [_optName, _optHelp]]; }
	else { _resultOpts set [_optVarName, _optDefaultValue]; };
} forEach _commandOpts;

// filter for long opts, short opts and other stuff/things
{
	if ( ((_x select [0, 2]) isEqualTo "--") && ((count _x) >= 4) ) then
	{
		// long form; min. count 4, because "--" + 2 or more chars
		private _resultsLongForm = [_computer, _x, _commandOpts] call AE3_armaos_fnc_shell_getOptsParseLongForm;
		_resultOpts merge [_resultsLongForm, true]; // overwrite existing
		continue;
	};

	if ( ((_x select [0, 1]) isEqualTo "-") && ((count _x) >= 2) ) then
	{
		// short form; min. count 2, because "-" + 1 or more chars
		private _resultsShortForm = [_computer, _x, _commandOpts] call AE3_armaos_fnc_shell_getOptsParseShortForm;
		_resultOpts merge [_resultsShortForm, true]; // overwrite existing
		continue;
	};

	// if it's not an option/arg, it must be something else, perhaps path/dir/ip/text or other
	_resultThings pushBack _x;
} forEach _options;

// add things as the additional reserved var "_ae3OptsThings" to the results
_resultOpts set ["_ae3OptsThings", _resultThings];

//check if required options are missing
_resultOpts set ["_ae3OptsSuccess", true];
{
	if (!(_x in _resultOpts)) then
	{
		// We can't throw errors because in fnc_she_executeFile.sqf a 'spawn' is used to call the function
		// With a spawn we can't catch errors to print them to stdout, so I do it here and return a '_ae3OptsSuccess' 
		//throw format ["Command option '%1' missing!", _y select 0];

		private _missingOptions = 
		[
			format ["Command option '%1' missing!", _y select 0],
			format ["Help: %1", _y select 1]
		];

		[_computer, _missingOptions] call AE3_armaos_fnc_shell_stdout;

		_resultOpts set ["_ae3OptsSuccess", false];
	};
} forEach _requiredOpts;

_result = _resultOpts toArray false; // Convert HashMap to Array

_result;