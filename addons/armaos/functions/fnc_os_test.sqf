params ["_computer", "_options"];

// perhaps we could define options in the OS Command config instead of hard-coded in the function
// last parameter at type arg is "isNumber"
private _optsSettings = createHashMap;
_optsSettings set ["l", ["bool", "_longOutput", false]];
_optsSettings set ["long", ["bool", "_longOutput", false]];
_optsSettings set ["h", ["bool", "_humanReadable", false]];
_optsSettings set ["human-readable", ["bool", "_humanReadable", false]];
_optsSettings set ["w", ["arg", "_width", 20, true]];
_optsSettings set ["width", ["arg", "_width", 20, true]];
_optsSettings set ["c", ["arg", "_comment", "helloworld", false]];
_optsSettings set ["comment", ["arg", "_comment", "helloworld", false]];

[] params ([_options, _optsSettings] call AE3_armaos_fnc_shell_getOpts); // initialising returned vars

{
	private _somethingString = format ["Something %1: %2", _forEachIndex, _x];
	[_computer, _somethingString] call AE3_armaos_fnc_shell_stdout;
} forEach _ae3OptsThings; // this is the reserved variable, returned by getOpts

private _results = [_options, _optsSettings] call AE3_armaos_fnc_shell_getOpts; // this line is for testing only
{
	private _optName = _x select 0;
	private _optValue = _x select 1;
	private _varString = format ["Name: %1 Value: %2", _optName, _optValue];
	[_computer, _varString] call AE3_armaos_fnc_shell_stdout;
} forEach _results; // this loop is for testing only

hint format ["long: %1 \n human-readable: %2 \n width: %3 (%4) \n comment: %5 (%6)", _longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment];