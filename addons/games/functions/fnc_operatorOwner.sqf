// File: fnc_operatorOwner.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the machine network id to send a device's game view to, or 0 when nobody is
 * sitting at it. The device's mutex holder is the test, not the locality number: a hosted or local
 * multiplayer game has its players on the server machine, so locality 2 means both "nobody is using
 * this device" and "the person using it is the host", and treating 2 as nobody leaves every host
 * player unanswered. Server only.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device
 *
 * Return Value:
 * Machine network id, or 0 when no one is using the device <NUMBER>
 *
 * Example:
 * private _owner = [_computer] call AE3_games_fnc_operatorOwner;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]]];

if (isNull _device) exitWith {0};

private _holder = _device getVariable ["AE3_computer_mutex", objNull];

// A free device has no holder, and a holder who has died or disconnected leaves the lock behind
if (isNull _holder) exitWith {0};
if (!(_holder isKindOf "CAManBase")) exitWith {0};
if (!alive _holder) exitWith {0};

private _owner = owner _holder;

if (_owner < 0) exitWith {0};

_owner
