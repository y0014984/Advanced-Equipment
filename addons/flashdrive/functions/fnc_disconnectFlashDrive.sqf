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

if(isNull _occupied) exitWith {};

[_occupied, _player] call AE3_flashdrive_fnc_obj2item;

if (_mounted) then 
{
	[_computer, _name] call AE3_flashdrive_fnc_unmount;
};

