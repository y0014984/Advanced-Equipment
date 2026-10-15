// File: fnc_pushNotice.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Tells whoever is using a device why a request was refused or what just happened at
 * their table. Only the stringtable key travels, because the server may well be a dedicated one
 * running a different language than the player; the client localizes it on arrival. Server only.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device whose operator is told
 * 1: _key <STRING> - Stringtable key, with or without a leading $
 *
 * Return Value:
 * None
 *
 * Example:
 * [_device, "$STR_AE3_Games_Status_NotYourTurn"] call AE3_games_fnc_pushNotice;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_key", "", [""]]];

if (!isServer) exitWith {};
if (isNull _device || (_key isEqualTo "")) exitWith {};

private _owner = [_device] call FUNC(operatorOwner);

if (_owner <= 0) exitWith {};

private _payload = createHashMapFromArray
[
    ["kind", "notice"],
    ["device", netId _device],
    ["textKey", _key]
];

["ae3_games_view", [[_payload] call CBA_fnc_encodeJSON], _owner] call CBA_fnc_ownerEvent;
