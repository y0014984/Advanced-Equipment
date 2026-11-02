// File: fnc_netScan.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Lists the AE3 routers the laptop may join (AE3_network_fnc_canConnect without password) for
 * the web Network app. Returns ssid, ip and netId per router for rendering and connect requests. Client-local read.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 *
 * Return Value:
 * Networks <ARRAY> of <HASHMAP> - keys: ssid, ip, netId, current, locked
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { [] };

private _scanCap = missionNamespace getVariable [QGVAR(wirelessRangeMax), 500];
private _parent = _computer getVariable ["AE3_network_parent", objNull];

// nearestObjects only finds routers that stand in the world. A router carried by a player - a backpack
// broadcasting a network - is not one of them, so the registry every router adds itself to on init is
// scanned alongside it. Both lists then face the same AE3_network_fnc_canConnect test, and the union is
// deduplicated so a router that appears in both is listed once.
private _candidates = nearestObjects [_computer, [], _scanCap];
{
   _candidates pushBackUnique _x;
} forEach (call AE3_network_fnc_getRouters);

private _routers = _candidates select {
    (_x != _computer) && {_x getVariable ["AE3_cap_isRouter", false]} &&
    {([_computer, _x] call AE3_network_fnc_canConnect) select 0}
};

private _list = [];
{
    private _ssid = [_x] call AE3_main_fnc_getDeviceName;
    _list pushBack createHashMapFromArray [
        ["ssid", _ssid],
        ["ip", ([_x getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str)],
        ["netId", netId _x],
        ["current", _x isEqualTo _parent],
        ["locked", (_x getVariable ["AE3_network_password", ""]) isNotEqualTo ""]
    ];
} forEach _routers;

_list
