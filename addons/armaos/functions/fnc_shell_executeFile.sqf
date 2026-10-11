// File: fnc_shell_executeFile.sqf
/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Executes a file from the filesystem. If the file contains executable code, spawns it as a process and waits for completion.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _path <STRING> - Path to the file to execute
 * 2: _options <ARRAY> - Command options and arguments
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "/bin/ls", ["-l"]] call AE3_armaos_fnc_shell_executeFile;
 *
 * Public: Yes
 */

params["_computer", "_path", "_options"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
// Superusers act as root over the filesystem here, exactly as they do in the desktop file manager.
private _username = [_computer] call AE3_armaos_fnc_shell_getFsUser;

// Executables registered as SSH-portable may come from the operator's own computer when the SSH
// target does not have them; they still run against the target.
private _findPortable = {
	params ["_computer", "_path"];
	private _source = [_computer] call AE3_armaos_fnc_shell_getSshSource;
	if (isNull _source) exitWith { nil };

	private _name = toLower (_path splitString "/" select -1);
	private _portable = missionNamespace getVariable ["AE3_armaos_sshPortableCommands", createHashMap];
	if !(_name in _portable) exitWith { nil };

	private _sourcePointer = _source getVariable ["AE3_filepointer", []];
	private _sourceFs = _source getVariable "AE3_filesystem";
	if (isNil "_sourceFs") exitWith { nil };
	private _sourceUser = [_source] call AE3_armaos_fnc_shell_getFsUser;

	private _candidates = [_path];
	{ _candidates pushBack (format ["%1/%2", _x, _name]); } forEach ((_portable get _name) + (_source getVariable ["AE3_ssh_toolDirs", []]));

	private _found = nil;
	{
		if (!isNil "_found") exitWith {};
		try
		{
			private _code = [_sourcePointer, _sourceFs, _x, _sourceUser, 2] call AE3_filesystem_fnc_getFile;
			if (_code isEqualType {}) then { _found = _code; };
		}
		catch {};
	} forEach _candidates;

	if (isNil "_found") exitWith { nil };
	_found
};

try
{
	private _content = nil;
	try
	{
		_content = [_pointer, _filesystem, _path, _username, 2] call AE3_filesystem_fnc_getFile;
	}
	catch
	{
		_content = [_computer, _path] call _findPortable;
		if (isNil "_content") then { throw _exception; };
	};

	if(_content isEqualType {}) then
	{
		private _commandName = _path splitString "/" select -1;
		private _handler = [_computer, _options, _commandName] spawn _content;
		_terminal set ["AE3_terminalProcess", _handler];
		_computer setVariable ["AE3_terminal", _terminal];

		// Wait until programm is finished
		waitUntil {
			isNull _handler;
		};
	}
	else
	{
		[_computer, [format [localize "STR_AE3_ArmaOS_Exception_CommandNotFound", _path]]] call AE3_armaos_fnc_shell_stdout;
		[_computer] call AE3_armaos_fnc_shell_playErrorSound;
	};

}catch{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};


