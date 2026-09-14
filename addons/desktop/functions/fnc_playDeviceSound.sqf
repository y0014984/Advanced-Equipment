// File: fnc_playDeviceSound.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Plays a positional device sound on each connected client. The engine applies the
 *              requested distance locally, keeping the sound audible only near its source.
 *
 * Arguments:
 * 0: _device <OBJECT> - Object that emits the sound
 * 1: _path <STRING> - Addon-relative sound path
 * 2: _volume <NUMBER> (Optional) - Loudness passed to playSound3D, default: 3
 *
 * Return Value:
 * None
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_path", "", [""]], ["_volume", 3, [0]]];

if (!hasInterface || {isNull _device} || _path isEqualTo "") exitWith {};

// A volume of zero is a caller asking for silence rather than for an inaudible sound, so nothing plays.
if (_volume <= 0) exitWith {};

playSound3D [_path, _device, false, getPosASL _device, _volume, 1, 20, 0, true];
