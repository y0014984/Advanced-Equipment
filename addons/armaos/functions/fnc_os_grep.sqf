// File: fnc_os_grep.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Searches file contents for lines matching a regular expression pattern.
 * Reduced unix grep: supports -i (ignore case) and -v (invert match) over one or more files.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments (pattern, file...)
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["-i", "error", "/var/log/syslog"], "grep"] call AE3_armaos_fnc_os_grep;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts =
	[
		["_ignoreCase", "i", "ignore-case", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Grep_ignoreCase"],
		["_invert", "v", "invert-match", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Grep_invert"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "PATTERN", true, false],
			["path", "FILEPATH", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
private _ignoreCase = false; private _invert = false;
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _pattern = _ae3OptsThings select 0;
private _files = _ae3OptsThings select [1, (count _ae3OptsThings) - 1];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

// Superusers act as root over the filesystem here, exactly as they do in the desktop file manager.
private _username = [_computer] call AE3_armaos_fnc_shell_getFsUser;

// SQF regex flags: 'i' = case insensitive (appended to the pattern after /)
private _regexPattern = _pattern;
if (_ignoreCase) then { _regexPattern = _regexPattern + "/i"; };

private _result = [];
private _multipleFiles = (count _files) > 1;

{
	private _path = _x;

	try
	{
		private _content = [_pointer, _filesystem, _path, _username, 0] call AE3_filesystem_fnc_getFile;

		if (!(_content isEqualType "")) then
		{
			_result pushBack (format [localize "STR_AE3_ArmaOS_Exception_UnableToRead", _path]);
			continue;
		};

		// Unicode-safe regex matching on user generated content
		forceUnicode 1;
		{
			private _matches = _x regexMatch _regexPattern;
			if (_matches isEqualTo !_invert) then
			{
				if (_multipleFiles) then
				{
					_result pushBack (format ["%1: %2", _path, _x]);
				}
				else
				{
					_result pushBack _x;
				};
			};
		} forEach (_content splitString endl);
		forceUnicode -1;
	}
	catch
	{
		[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
	};

} forEach _files;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;
