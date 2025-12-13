/*
 * Author: Root, Wasserstoff
 * Description: Physically disconnects a flash drive from a computer's USB interface, unmounting it if necessary and converting the object back to an inventory item
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer object to disconnect the flash drive from
 * 1: _player <OBJECT> - Player executing the disconnection action
 * 2: _USBInterface <ARRAY> - USB interface configuration [index, name, relPos, rotYaw, rotPitch, rotRoll]
 *
 * Return Value:
 * None
 *
 * Example:
 * [laptop, player, [0, "usb0", [0,0,0], 0, 0, 0]] call AE3_flashdrive_fnc_disconnectFlashDrive;
 *
 * Public: Yes
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
