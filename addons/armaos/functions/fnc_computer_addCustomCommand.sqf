/*
 * Author: Root
 * Description: Adds a custom command to a computer without requiring config file entries. This makes it easy to add unique commands to specific computers dynamically at runtime.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to add the command to
 * 1: _commandName <STRING> - The name users will type (e.g., "nano", "vim")
 * 2: _commandPath <STRING> - Where the command is stored in the filesystem (e.g., "/bin/nano", "/usr/bin/vim")
 * 3: _commandCode <CODE or STRING> - The SQF code to execute (receives [_computer, _options, _commandName])
 * 4: _description <STRING> (Optional, default: "") - Short description for help
 * 5: _manual <STRING> (Optional, default: "") - Full manual/help text
 * 6: _owner <STRING> (Optional, default: "root") - Owner of the command file
 * 7: _permissions <ARRAY> (Optional, default: [[true,true,false],[true,false,false]]) - File permissions
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_computer, "nano", "/bin/nano", {[_this select 0, "Nano v1.0"] call AE3_armaos_fnc_shell_stdout;}, "Simple text editor"] call AE3_armaos_fnc_computer_addCustomCommand;
 *
 * Public: Yes
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
