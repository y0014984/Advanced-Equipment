// File: fnc_device_writeFile.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Writes (or appends) content to a file on a device, creating the file and any missing
 * parent directories when needed. Safe to call from any machine and while a player is using the
 * device: the write is routed to the server and applied to the authoritative filesystem copy, so
 * an open terminal, desktop or SSH session sees it immediately and does not overwrite it on exit.
 * Runs asynchronously.
 *
 * Arguments:
 * 0: _computer <OBJECT|STRING> - Device object (laptop, server or flash drive) or its netId
 * 1: _path <STRING> - Absolute path of the file
 * 2: _content <STRING|CODE> - Content to write (CODE makes the file executable; cannot be appended)
 * 3: _append <BOOL> (Optional, default: false) - Append to existing content instead of replacing it
 * 4: _create <BOOL> (Optional, default: true) - Create the file (and parent directories) if missing
 * 5: _owner <STRING> (Optional, default: "root") - Owner when the file is created
 * 6: _permissions <ARRAY> (Optional, default: [[true,true,false],[true,false,false]]) - Permissions when created
 * 7: _size <NUMBER|STRING> (Optional, default: -1) - Virtual file size (bytes or "50MB"); -1 keeps the current size
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "/home/user/notes.txt", "Meet at the bridge."] call AE3_filesystem_fnc_device_writeFile;
 * [_laptop, "/var/log/ops.log", "Entry" + endl, true] call AE3_filesystem_fnc_device_writeFile;
 * [_server, "/data/deathstar_plans.bin", "<binary>", false, true, "root", [[true,true,false],[true,false,false]], "800MB"] call AE3_filesystem_fnc_device_writeFile;
 *
 * Public: Yes
 */

params [
	["_computer", objNull, [objNull, ""]],
	["_path", "", [""]],
	["_content", "", ["", {}]],
	["_append", false, [false]],
	["_create", true, [true]],
	["_owner", "root", [""]],
	["_permissions", [[true, true, false], [true, false, false]], [[]]],
	["_size", -1, [0, ""]]
];

if (!isServer) exitWith
{
	private _targetId = [_computer, netId _computer] select (_computer isEqualType objNull);
	["ae3_filesystem_writeFile", [_targetId, _path, _content, _append, _create, _owner, _permissions, _size]] call CBA_fnc_serverEvent;
};

if (_computer isEqualType "") then { _computer = objectFromNetId _computer; };

if (isNull _computer || _path isEqualTo "") exitWith
{
	ERROR_2("device_writeFile called with invalid target %1 or empty path %2",_computer,_path);
};

if (_append && {_content isEqualType {}}) exitWith
{
	ERROR_1("device_writeFile cannot append code content: %1",_path);
};

_size = [_size] call AE3_filesystem_fnc_parseSize;

[_computer, {
	params ["_fs", "_blockArgs"];
	_blockArgs params ["_filePath", "_fileContent", "_doAppend", "_doCreate", "_fileOwner", "_filePerms", "_fileSize"];

	if (_doCreate) then
	{
		[[], _fs, _filePath, "", "root", _fileOwner, _filePerms] call AE3_filesystem_fnc_ensureFile;
	};

	[[], _fs, _filePath, "root", _fileContent, _doAppend] call AE3_filesystem_fnc_writeToFile;

	if (_fileSize >= 0) then
	{
		[[], _fs, _filePath, "root", _fileSize] call AE3_filesystem_fnc_setFileSize;
	};
}, [_path, _content, _append, _create, _owner, _permissions, _size]] spawn AE3_filesystem_fnc_device_withFilesystem;
