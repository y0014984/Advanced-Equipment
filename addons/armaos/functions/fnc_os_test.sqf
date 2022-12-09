params ["_computer", "_options"];

private _commandOpts =
	[
		// 0: var name, 1: short, 2: long, 3: type, 4: default, 5: required, 6: help
		// types "bool", "string", "number"
		// enhancement: type "selectString", "selectNumber" --> choose from predefined values like ["encrypt","decrypt"] for crypto
		["_longOutput", "l", "long", "bool", false, false, "long output format, containing permissions and owner"],
		["_humanReadable", "h", "human-readable", "bool", false, false, "converts bytes into kbytes, Mbytes and so on"],
		["_width", "w", "width", "number", 5, false, "the width of ..."],
		["_comment", "c", "comment", "string", false, false, "things you want to say"],
		["_mode", "", "mode", "string", "", true, "encode or decode"]
	];

[] params ([_options, _commandOpts] call AE3_armaos_fnc_shell_getOpts); // initialising returned vars

{
	private _somethingString = format ["Something %1: %2", _forEachIndex, _x];
	[_computer, _somethingString] call AE3_armaos_fnc_shell_stdout;
} forEach _ae3OptsThings; // this is the reserved variable, returned by getOpts

hint format ["long: %1 \n human-readable: %2 \n width: %3 (%4) \n comment: %5 (%6), mode: %7", _longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment, _mode];