// File: fnc_mapData.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Provides a player-centred minimap snapshot for the web Map app. A native
 * RscMapControl cannot render inside the CEF page, so the Map app draws a schematic canvas from this data instead:
 * player position/heading plus nearby AE3 devices as blips, all relative to the player. Read-only,
 * client-local.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop (shown as a blip)
 * 1: _data <HASHMAP> - optional, key "range" <NUMBER> view radius in metres (default 250)
 *
 * Return Value:
 * Snapshot <HASHMAP> - keys: world <STRING>, dir <NUMBER>, range <NUMBER>, blips <ARRAY>
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_data", createHashMap, [createHashMap]]];

private _range = _data getOrDefault ["range", 250];
private _self = player;
private _pos = getPosVisual _self;
_pos params ["_px", "_py"];

private _blips = [];

private _sameOnly = AE3_Desktop_MapSameNetworkOnly && {!isNull _computer};

// Nearby AE3 devices (laptops, routers, equipment) as blips relative to the player.
{
    if ((isClass (configOf _x >> "AE3_Device") || {_x getVariable ["AE3_cap_isRouter", false]}) && {!_sameOnly || {[_computer, _x] call AE3_network_fnc_sameNetwork}}) then {
        (getPosVisual _x) params ["_x2", "_y2"];
        private _kind = if (_x isEqualTo _computer) then { "self" } else {
            ["device", "router"] select (_x getVariable ["AE3_cap_isRouter", false])
        };
        private _label = _x getVariable ["ace_cargo_customName", ""];
        _blips pushBack createHashMapFromArray [
            ["dx", _x2 - _px], ["dy", _y2 - _py], ["kind", _kind], ["label", _label]
        ];
    };
} forEach (nearestObjects [_self, [], _range]);

createHashMapFromArray [
    ["world", worldName],
    ["dir", getDirVisual _self],
    ["range", _range],
    ["blips", _blips]
]
