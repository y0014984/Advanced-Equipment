/**
 * Physically disconects a flash drive from a computer
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Player <OBJECT>
 * 3: Interface state <ARRAY>
 *
 * Results:
 * None
 */

params['_computer', '_player', '_USBInterface'];

_USBInterface params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];

diag_log str _mounted;
if(isNull _occupied) exitWith {};

[_occupied, _player] call AE3_flashdrive_fnc_obj2item;

if (_mounted) then 
{
	private _filesystem = _computer getVariable "AE3_filesystem";
	[
		[],
		_filesystem,
		format ["/mnt/%1", _name],
		"root"
	] call AE3_filesystem_fnc_delObj;

	_computer setVariable ["AE3_filesystem", _filesystem, 2];
};

_USBInterface set [0, objNull];