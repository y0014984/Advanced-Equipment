// File: fnc_disconnectFlashDrive.sqf
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

if (isNull _computer) exitWith {};

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

private _item = [_occupied, _player] call AE3_flashdrive_fnc_obj2item;

// Free the interface slot so the drive can be reconnected and the laptop's occupied state stays
// consistent (a leftover reference to the now-deleted object otherwise lingers in the list).
_occupiedList set [_index, objNull];
_computer setVariable ["AE3_USB_Interfaces_occupied", _occupiedList, true];

// Tell any open desktop that the volume set changed, so the freed slot becomes connectable again
// without reopening the laptop (connect/mount/unmount raise the same event).
["ae3_desktop_volChanged", []] call CBA_fnc_globalEvent;

// Removing a drive is announced with the same sound the drive arrived with, and obeys the same enable
// and volume settings, so silencing a drive silences it in both directions. Missing settings read as
// sound on, which is what AE3 does without them.
private _isDucky = (typeOf _occupied) find "ROOT_Rubberducky" == 0;
private _soundEnabled = missionNamespace getVariable [
    ["ROOT_CYBERWARFARE_USB_SOUND_ENABLED", "ROOT_CYBERWARFARE_DUCKY_SOUND_ENABLED"] select _isDucky,
    true
];

if (_soundEnabled) then {
    private _sound = ["\z\ae3\addons\flashdrive\audio\usb_connect.ogg", "\z\root_cyberwarfare\addons\main\audio\ducky_connected.ogg"] select _isDucky;
    private _volume = missionNamespace getVariable ["ROOT_CYBERWARFARE_DEVICE_SOUND_VOLUME", 3];
    [_computer, _sound, _volume] remoteExecCall ["AE3_desktop_fnc_playDeviceSound", 0];
};

_item
