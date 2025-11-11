/*
 * Author: Root
 * Description: Initializes a computer with a specific set of commands from CfgOsFunctions, security commands, games, and custom commands. This makes it easy to create computers with different command sets.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to initialize
 * 1: _baseCommands <ARRAY> (Optional, default: ["all"]) - Array of command names from CfgOsFunctions to include, use ["all"] for all commands, [] for none
 * 2: _includeSecurity <BOOL> (Optional, default: false) - Include security commands (crypto, crack)
 * 3: _includeGames <BOOL> (Optional, default: false) - Include games (snake)
 * 4: _customCommands <ARRAY> (Optional, default: []) - Array of custom command definitions [name, path, code, description, manual]
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["ls", "cd", "cat"], true, false, []] call AE3_armaos_fnc_computer_initWithCommands;
 *
 * Public: Yes
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
