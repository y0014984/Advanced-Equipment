// File: fnc_connectFlashDrive.sqf
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

_object setVariable ['AE3_Flashdrive_Parent', _computer, true];
_object setVariable ['AE3_Flashdrive_Interface', _name, true];

[_object, "AE3_Flashdrive_takeEH", {
	params['_flashdrive', '_player'];

	private _computer = _flashdrive getVariable 'AE3_Flashdrive_Parent';
	private _interface_name = _flashdrive getVariable 'AE3_Flashdrive_Interface';

	// The parent laptop may have been removed (e.g. picked up into inventory) while the drive was
	// still attached; without it there is nothing to disconnect from, so just drop the handler.
	if (isNull _computer) exitWith {
		[_flashDrive, "AE3_Flashdrive_takeEH", _thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;
		true;
	};

	private _interfaces = _computer getVariable "AE3_USB_Interfaces";

	[_computer, _player, _interfaces get _interface_name] call AE3_flashdrive_fnc_disconnectFlashDrive;

	[_flashDrive, "AE3_Flashdrive_takeEH", _thisScriptedEventHandler] call BIS_fnc_removeScriptedEventHandler;

	true;
}] call BIS_fnc_addScriptedEventHandler;

// Auto-mount the freshly connected drive so it shows up in My Computer / the file browser,
// then nudge any open desktop to refresh its volume list.
[_computer, _name, "root"] remoteExecCall ["AE3_flashdrive_fnc_mount", 2];
["ae3_desktop_volChanged", []] call CBA_fnc_globalEvent;

// A Rubberducky announces itself with its own sound, every other drive with the standard one. Each has
// its own enable setting and both share a volume, so a mission can silence one kind of drive, quieten
// both, or leave them alone. Missing settings read as sound on, which is what AE3 does without them.
private _isDucky = (typeOf _object) find "ROOT_Rubberducky" == 0 || {_flashDrive find "ROOT_Rubberducky" == 0};
private _soundEnabled = missionNamespace getVariable [
    ["ROOT_CYBERWARFARE_USB_SOUND_ENABLED", "ROOT_CYBERWARFARE_DUCKY_SOUND_ENABLED"] select _isDucky,
    true
];

if (_soundEnabled) then {
    private _sound = ["\z\ae3\addons\flashdrive\audio\usb_connect.ogg", "\z\root_cyberwarfare\addons\main\audio\ducky_connected.ogg"] select _isDucky;
    private _volume = missionNamespace getVariable ["ROOT_CYBERWARFARE_DEVICE_SOUND_VOLUME", 3];
    [_computer, _sound, _volume] remoteExecCall ["AE3_desktop_fnc_playDeviceSound", 0];
};
