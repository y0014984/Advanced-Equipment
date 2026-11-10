// File: fnc_computer_release.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Hands a computer back: releases the mutex, restores the running screen texture and clears
 * the ACE "in use" state, so the laptop is offered to everyone again. This is the single release path
 * shared by the terminal and desktop unload handlers and by the watchers that pull a user out of a
 * session they can no longer be in (death, unconsciousness, respawn).
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer to release
 * 1: _texture <STRING> (Optional, default: the desktop idle screen) - Idle screen to restore. The
 *    terminal and the desktop show different running screens, so the caller names the one it left behind.
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_armaos_fnc_computer_release;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_texture", "\z\ae3\addons\armaos\textures\Laptop_PowerOn.paa", [""]]];

if (isNull _computer) exitWith {};

_computer setObjectTextureGlobal [1, _texture];
_computer setVariable ["AE3_computer_mutex", objNull, true];
_computer setVariable ["AE3_filesystem_syncedBy", objNull, true];

[_computer, "inUse", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
