params ["_computer", "_options"];

private _commandOpts =
	[
		// if long or short form are empty then they have no short or long form, so just one of them
		// allowed types: "bool", "string", "number", "stringSelect", "numberSelect"
		// enhancement: type "path", "pathExisting" --> check if exists
		// 0: var name,		1: short, 2: long, 			3: type, 		4: default, 5: required, 6: help, 												7: allowed values (mandatory only if a select-type is used)
		["_longOutput", 	"l", 	"long", 			"bool", 		false, 	false, 	"prints long output format, containing permissions and owner"],
		["_humanReadable",	"h", 	"human-readable", 	"bool", 		false, 	false, 	"converts bytes into kbytes, Mbytes and so on"],
		["_width", 			"w", 	"width", 			"number", 		5, 		false, 	"sets the width of ..."],
		["_comment", 		"c", 	"comment", 			"string", 		false, 	false, 	"prints things you want to say"],
		["_mode", 			"m", 	"mode", 			"stringSelect", "", 	true, 	"sets the mode", 												["encode", "decode"]],
		["_algorithm", 		"a", 	"algorithm", 		"stringSelect", "", 	true, 	"sets the algorithm", 											["caesar"]],
		["_delay", 			"d", 	"delay", 			"numberSelect", "1", 	false, 	"sets the delay in seconds", 									[1, 3, 5]],
		["_experimental1", 	"x", 	"", 				"bool", 		false, 	false, 	"example for an option with only short version"],
		["_experimental2", 	"", 	"exp", 				"bool", 		false, 	false, 	"example for an option with only long version"]
	];

[] params ([_computer, _options, _commandOpts] call AE3_armaos_fnc_shell_getOpts); // initialising returned vars

if (_ae3OptsSuccess) then
{
	{
		private _somethingString = format ["Something %1: %2", _forEachIndex, _x];
		[_computer, _somethingString] call AE3_armaos_fnc_shell_stdout;
	} forEach _ae3OptsThings; // this is the reserved variable, returned by getOpts

	hint format ["long: %1 \n human-readable: %2 \n width: %3 (%4) \n comment: %5 (%6) \n mode: %7 \n algorithm: %8 \n experimental1: %9 \n experimental2: %10 \n delay: %11", 
	_longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment, _mode, _algorithm, _experimental1, _experimental2, _delay];
};