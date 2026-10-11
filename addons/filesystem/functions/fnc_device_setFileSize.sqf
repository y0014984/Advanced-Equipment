// File: fnc_device_setFileSize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the virtual size of an existing file or directory entry on a device. The virtual
 * size only affects how long copies and downloads take and what size listings show; the content is
 * unchanged. Safe to call from any machine and while the device is in use. Runs asynchronously.
 *
 * Arguments:
 * 0: _computer <OBJECT|STRING> - Device object or its netId
 * 1: _path <STRING> - Absolute path of the file
 * 2: _size <NUMBER|STRING> - Size in bytes or with a unit ("750KB", "12MB", "1.5GB"); -1 restores the real size
 *
 * Return Value:
 * None
 *
 * Example:
 * [_server, "/data/deathstar_plans.bin", "800MB"] call AE3_filesystem_fnc_device_setFileSize;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull, ""]], ["_path", "", [""]], ["_size", -1, [0, ""]]];

if (!isServer) exitWith
{
	private _targetId = [_computer, netId _computer] select (_computer isEqualType objNull);
	["ae3_filesystem_setFileSize", [_targetId, _path, _size]] call CBA_fnc_serverEvent;
};

if (_computer isEqualType "") then { _computer = objectFromNetId _computer; };
if (isNull _computer) exitWith {};

_size = [_size] call AE3_filesystem_fnc_parseSize;

[_computer, {
	params ["_fs", "_blockArgs"];
	_blockArgs params ["_filePath", "_fileSize"];
	[[], _fs, _filePath, "root", _fileSize] call AE3_filesystem_fnc_setFileSize;
}, [_path, _size]] spawn AE3_filesystem_fnc_device_withFilesystem;
