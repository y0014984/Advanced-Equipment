/**
 * Initializes a computer with a specific set of commands.
 * This makes it easy to create computers with different command sets.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Base Commands <ARRAY> (Optional) - Array of command names from CfgOsFunctions to include
 *                                        Use ["all"] for all commands, [] for none
 *                                        Default: ["all"]
 * 2: Security Commands <BOOL> (Optional) - Include security commands (crypto, crack)
 *                                           Default: false
 * 3: Games <BOOL> (Optional) - Include games (snake)
 *                               Default: false
 * 4: Custom Commands <ARRAY> (Optional) - Array of custom command definitions [name, path, code, description, manual]
 *                                          Default: []
 *
 * Results:
 * None
 *
 * Examples:
 *   // Computer with all standard commands
 *   [_computer] call AE3_armaos_fnc_computer_initWithCommands;
 *
 *   // Computer with only basic file commands
 *   [_computer, ["ls", "cd", "pwd", "cat", "mkdir"]] call AE3_armaos_fnc_computer_initWithCommands;
 *
 *   // Computer with all commands plus security tools
 *   [_computer, ["all"], true] call AE3_armaos_fnc_computer_initWithCommands;
 *
 *   // Computer with custom command set
 *   [
 *       _computer,
 *       ["ls", "cd", "cat"],
 *       false,
 *       false,
 *       [
 *           ["nano", "/bin/nano", {hint "Nano editor"}, "Text editor", "nano [file]"]
 *       ]
 *   ] call AE3_armaos_fnc_computer_initWithCommands;
 */

params [
	"_computer",
	["_baseCommands", ["all"]],
	["_includeSecurity", false],
	["_includeGames", false],
	["_customCommands", []]
];

// Validate computer
if (isNull _computer) exitWith {
	["AE3_armaos_fnc_computer_initWithCommands: Invalid computer object"] call BIS_fnc_error;
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];
if (isNil "_filesystem") exitWith {
	["AE3_armaos_fnc_computer_initWithCommands: Computer has no filesystem initialized"] call BIS_fnc_error;
};

// Initialize base commands from CfgOsFunctions
try {
	[_computer, "CfgOsFunctions", _baseCommands] call AE3_armaos_fnc_link_init;
} catch {
	[format ["AE3_armaos_fnc_computer_initWithCommands: Failed to initialize base commands: %1", _exception]] call BIS_fnc_error;
};

// Add security commands if requested
if (_includeSecurity) then {
	try {
		[_computer, "CfgSecurityCommands", ["all"]] call AE3_armaos_fnc_link_init;
	} catch {
		[format ["AE3_armaos_fnc_computer_initWithCommands: Failed to initialize security commands: %1", _exception]] call BIS_fnc_error;
	};
};

// Add games if requested
if (_includeGames) then {
	try {
		[_computer, "CfgGames", ["all"]] call AE3_armaos_fnc_link_init;
	} catch {
		[format ["AE3_armaos_fnc_computer_initWithCommands: Failed to initialize games: %1", _exception]] call BIS_fnc_error;
	};
};

// Add custom commands
{
	_x params [
		"_name",
		"_path",
		"_code",
		["_desc", ""],
		["_man", ""]
	];

	[_computer, _name, _path, _code, _desc, _man] call AE3_armaos_fnc_computer_addCustomCommand;
} forEach _customCommands;
