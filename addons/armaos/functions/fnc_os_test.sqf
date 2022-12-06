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

private _results = [_options, _optsSettings] call AE3_armaos_fnc_shell_getOpts;

private _resultOpts = _results select 0; // HashMap
_resultOpts = _resultOpts toArray false; // Convert HashMap to Array
[] params _resultOpts; // initialising returned vars
private _resultThings = _results select 1;

{
	private _optName = _x select 0;
	private _optValue = _x select 1;
	private _result = format ["Name: %1 Value: %2", _optName, _optValue];
	[_computer, _result] call AE3_armaos_fnc_shell_stdout;
} forEach _resultOpts;

{
	private _result = format ["Something %1: %2", _forEachIndex, _x];
	[_computer, _result] call AE3_armaos_fnc_shell_stdout;
} forEach _resultThings;

hint format ["long: %1 \n human-readable: %2 \n width: %3 (%4) \n comment: %5 (%6)", _longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment];