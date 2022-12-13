params ["_computer", "_options"];

private _commandName = "test";
/*
private _commandOpts =
	[
		// if long or short form are empty then they have no short or long form, so just one of them
		// allowed types: "bool", "string", "number", "stringSelect", "numberSelect", "file", "folder", "fileExist", "fileNonExist", "folderExist", "folderNonExist"
		// 0: var name,		1: short, 2: long, 			3: type, 			4: default, 	5: required, 6: help, 													7: allowed values (mandatory only if a select-type is used)
		["_longOutput", 	"l", 	"long", 			"bool", 			false, 			false, 	"prints long output format, containing permissions and owner"],
		["_humanReadable",	"h", 	"human-readable", 	"bool", 			false, 			false, 	"converts bytes into kbytes, Mbytes and so on"],
		["_width", 			"w", 	"width", 			"number", 			5, 				false, 	"sets the width of ..."],
		["_comment", 		"c", 	"comment", 			"string", 			"", 			false, 	"prints things you want to say"],
		["_mode", 			"m", 	"mode", 			"stringSelect", 	"", 			true, 	"sets the mode", 												["encode", "decode"]],
		["_algorithm", 		"a", 	"algorithm", 		"stringSelect", 	"", 			true, 	"sets the algorithm", 											["caesar"]],
		["_delay", 			"", 	"delay", 			"numberSelect", 	"1", 			false, 	"sets the delay in seconds", 									[1, 3, 5]],
		["_experimental1", 	"x", 	"", 				"bool", 			false, 			false, 	"example for an option with only short version"],
		["_experimental2", 	"", 	"exp", 				"bool", 			false, 			false, 	"example for an option with only long version"],
		["_file1",	 		"", 	"file1",			"file",				"/var/obj1", 	false, 	"sets a file"],
		["_folder1",	 	"", 	"folder1",			"folder",			"/var/",		false, 	"sets a folder"],
		["_inFile", 		"i", 	"input", 			"fileExist",		"", 			true, 	"sets the input file"],
		["_outFile", 		"o", 	"output", 			"fileNonExist",		"", 			true, 	"sets the output file"],
		["_inFolder", 		"s", 	"source", 			"folderExist",		"", 			true, 	"sets the source folder"],
		["_outFolder", 		"d", 	"destination",		"folderNonExist",	"", 			true, 	"sets the destination folder"]
	];
*/

private _commandOpts =
	[
		["_longOutput", 	"l", 	"long", 			"bool", 			false, 			false, 	"prints long output format, containing permissions and owner"],
		["_humanReadable",	"h", 	"human-readable", 	"bool", 			false, 			false, 	"converts bytes into kbytes, Mbytes and so on"]
	];

private _commandSyntax =
[
	[
		// There could be multiple syntax variants in this array
		// allowed syntax types: command, options, path, ip, string, number
		//	0: Syntax Element,	1: Syntax Name		2: Required 3: unlimited
			["command", 			"test",			true,		false],
			["options", 			"OPTION",		false,		false],
			["path",				"PATH",			true, 		false]	
	],
	[
			["command", 			"test",			true,		false],
			["options", 			"OPTION",		false,		false],
			["path",				"PATH1",		true,		false],
			["path",				"PATH2",		true,		false]
	],
	[
			["command", 			"test",			true,		false],
			["options", 			"OPTION",		false,		false],
			["path",				"PATH",			true,		true]
	]
];

/*
	SYNTAX EXAMPLES:

	cat [OPTION] PATH
	cp [OPTION] SOURCE DIRECTORY
	mv [OPTION] SOURCE DIRECTORY
	ls [OPTION] [PATH]
	exit
	crypto [OPTION] MESSAGE
*/

private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts); // initialising returned vars

if (_ae3OptsSuccess) then
{
	{
		private _somethingString = format ["Something %1: %2", _forEachIndex, _x];
		[_computer, _somethingString] call AE3_armaos_fnc_shell_stdout;
	} forEach _ae3OptsThings; // this is the reserved variable, returned by getOpts

/* 	hint format [
		"long: %1" + endl + 
		"human-readable: %2" + endl + 
		"width: %3 (%4)" + endl + 
		"comment: %5 (%6)" + endl +
		"mode: %7" + endl +
		"algorithm: %8" + endl +
		"experimental1: %9" + endl + 
		"experimental2: %10" + endl + 
		"delay: %11" + endl +
		"File1: %12" + endl +
		"Folder1: %13" + endl +
		"Input File: %14" + endl +
		"Output File: %15" + endl +
		"Source Folder: %16" + endl +
		"Destination Folder: %17",
	_longOutput, _humanReadable, _width, typeName _width, _comment, typeName _comment, _mode, _algorithm, 
	_experimental1, _experimental2, _delay, _file1, _folder1, _inFile, _outFile, _inFolder, _outFolder]; */
};