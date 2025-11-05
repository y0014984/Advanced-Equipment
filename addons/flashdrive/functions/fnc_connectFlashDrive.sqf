/**
 * Physically connects a flash drive to a computer
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Executing player <OBJECT>
 * 3: Flashdrive type <STRING>
 * 4: Interface state <ARRAY>
 *
 * Results:
 * None
 */

params['_computer', '_player', '_flashDrive', '_USBInterface'];

_USBInterface params ['_index', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];

private _occupiedList = _computer getVariable "AE3_USB_Interfaces_occupied";
private _occupied = _occupiedList select _index;

if(!(isNull _occupied)) exitWith {};

private _object = [_player, _flashDrive] call AE3_flashdrive_fnc_item2obj;

if(isNull _object) exitWith {};

_object attachTo [_computer, _rel_pos];
[_object, [_rot_yaw, _rot_pitch, _rot_roll]] call BIS_fnc_setObjectRotation;

_occupiedList set [_index, _object];
_computer setVariable ["AE3_USB_Interfaces_occupied", _occupiedList, true];

_object setVariable ['AE3_Flashdrive_Parent', _computer];
_object setVariable ['AE3_Flashdrive_Interface', _name];

[_object, "AE3_Flashdrive_takeEH", {
	params['_flashdrive', '_player'];

	private _computer = _flashDrive getVariable 'AE3_Flashdrive_Parent';
	private _interface_name = _flashDrive getVariable 'AE3_Flashdrive_Interface';
	private _interfaces = _computer getVariable "AE3_USB_Interfaces";

	[_computer, _player, _interfaces get _interface_name] call AE3_flashdrive_fnc_disconnectFlashDrive;

	[_flashDrive, "AE3_Flashdrive_takeEH", _thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;

	true;
}] call BIS_fnc_addScriptedEventHandler;
