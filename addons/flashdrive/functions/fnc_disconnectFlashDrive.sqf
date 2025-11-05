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

_USBInterface params ['_index', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
private _occupiedList = _computer getVariable "AE3_USB_Interfaces_occupied";
private _mountedList = _computer getVariable "AE3_USB_Interfaces_mounted";
private _occupied = _occupiedList select _index;
private _mounted = _mountedList select _index;

if(isNull _occupied) exitWith {};

if (_mounted) then 
{
	[_computer, _name] call AE3_flashdrive_fnc_unmount;
};

[_occupied, _player] call AE3_flashdrive_fnc_obj2item;
