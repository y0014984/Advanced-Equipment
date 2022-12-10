params ["_computer", "_options"];

private _commandOpts =
	[
		// if long or short form are empty then they have no short or long form, so just one of them
		// 0: var name, 1: short, 2: long, 3: type, 4: default, 5: required, 6: help
		// types "bool", "string", "number"
		// enhancement: type "selectString", "selectNumber" --> choose from predefined values like ["encrypt","decrypt"] for crypto
		// enhancement: type "path", "pathExisting" --> check if exists
		["_longOutput", "l", "long", "bool", false, false, "prints long output format, containing permissions and owner"],
		["_humanReadable", "h", "human-readable", "bool", false, false, "converts bytes into kbytes, Mbytes and so on"],
		["_width", "w", "width", "number", 5, false, "sets the width of ..."],
		["_comment", "c", "comment", "string", false, false, "prints things you want to say"],
		["_mode", "m", "mode", "string", "", true, "sets the mode; allowed args 'encode' or 'decode'"],
		["_algorithm", "a", "algorithm", "string", "", true, "sets the algorith; allowed args 'caesar'"],
		["_experimental1", "x", "", "bool", false, false, "example for an option with only short version"],
		["_experimental2", "", "exp", "bool", false, false, "example for an option with only long version"]
	];

[] params ([_computer, _options, _commandOpts] call AE3_armaos_fnc_shell_getOpts); // initialising returned vars

if (_ae3OptsSuccess) then
{
	{
		private _somethingString = format ["Something %1: %2", _forEachIndex, _x];
		[_computer, _somethingString] call AE3_armaos_fnc_shell_stdout;
	} forEach _ae3OptsThings; // this is the reserved variable, returned by getOpts

	hint format ["long: %1 \n human-readable: %2 \n width: %3 (%4) \n comment: %5 (%6) \n mode: %7 \n algorithm: %8 \n experimental1: %9 \n experimental2: %10", 
	_longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment, _mode, _algorithm, _experimental1, _experimental2];
};