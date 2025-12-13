/*
 * Author: Root, Wasserstoff
 * Description: Physically connects a flash drive item to a computer's USB interface, converting the item to an object and attaching it to the computer
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer object to connect the flash drive to
 * 1: _player <OBJECT> - Player executing the connection action
 * 2: _flashDrive <STRING> - Class name of the flash drive item
 * 3: _USBInterface <ARRAY> - USB interface configuration [index, name, relPos, rotYaw, rotPitch, rotRoll]
 *
 * Return Value:
 * None
 *
 * Example:
 * [laptop, player, "Item_FlashDisk_AE3_ID_1", [0, "usb0", [0,0,0], 0, 0, 0]] call AE3_flashdrive_fnc_connectFlashDrive;
 *
 * Public: Yes
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
