/**
 * Adds a custom command to a computer without requiring config file entries.
 * This makes it easy to add unique commands to specific computers.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Command Name <STRING> - The name users will type (e.g., "nano", "vim")
 * 2: Command Path <STRING> - Where the command is stored in the filesystem (e.g., "/bin/nano", "/usr/bin/vim")
 * 3: Command Code <CODE or STRING> - The SQF code to execute (receives [_computer, _options, _commandName])
 * 4: Description <STRING> (Optional) - Short description for help
 * 5: Manual Text <STRING> (Optional) - Full manual/help text
 * 6: File Owner <STRING> (Optional, default: "root") - Owner of the command file
 * 7: File Permissions <ARRAY> (Optional, default: [[true,true,false],[true,false,false]]) - File permissions
 *
 * Results:
 * Success <BOOL>
 *
 * Example:
 *   [
 *       _computer,
 *       "nano",
 *       "/bin/nano",
 *       {
 *           params ["_computer", "_options", "_commandName"];
 *           private _terminal = _computer getVariable "AE3_terminal";
 *           [_computer, "Nano editor v1.0 - Not yet implemented"] call AE3_armaos_fnc_shell_stdout;
 *       },
 *       "Simple text editor",
 *       "nano [filename]\n\nA simple text editor for the terminal."
 *   ] call AE3_armaos_fnc_computer_addCustomCommand;
 */

params [
	"_computer",
	"_commandName",
	"_commandPath",
	"_commandCode",
	["_description", ""],
	["_manual", ""],
	["_owner", "root"],
	["_permissions", [[true, true, false], [true, false, false]]]
];

// Validate parameters
if (isNull _computer) exitWith {
	["AE3_armaos_fnc_computer_addCustomCommand: Invalid computer object"] call BIS_fnc_error;
	false
};

if (_commandName isEqualTo "" || _commandPath isEqualTo "") exitWith {
	["AE3_armaos_fnc_computer_addCustomCommand: Command name and path cannot be empty"] call BIS_fnc_error;
	false
};

if (typeName _commandCode == "STRING") then {
	_commandCode = compile _commandCode;
};

if (typeName _commandCode != "CODE") exitWith {
	["AE3_armaos_fnc_computer_addCustomCommand: Command code must be CODE or STRING"] call BIS_fnc_error;
	false
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];
if (isNil "_filesystem") exitWith {
	["AE3_armaos_fnc_computer_addCustomCommand: Computer has no filesystem initialized"] call BIS_fnc_error;
	false
};

try {
	// Create the command file in the filesystem
	[[], _filesystem, _commandPath, _commandCode, _owner, "root", _permissions] call AE3_filesystem_fnc_createFile;

	// Add the command link
	[_computer, _commandName, _commandPath, _description, _manual] call AE3_armaos_fnc_link_add;

	true
} catch {
	[format ["AE3_armaos_fnc_computer_addCustomCommand: Failed to add command '%1': %2", _commandName, _exception]] call BIS_fnc_error;
	false
};
